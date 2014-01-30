class QuestionsController < ApplicationController


#Return HTML form for creating a new question
#Requires: Nothing
#Modifies: Nothing
#Effects: Renders page for creating a new question
  def new
    @question = Question.new
  end

#Creates a new question
#Requires: user is logged in, Question Title, Question Content, is_anon param
#Modifies: Question Table
#Effects: Creates a new question
  def create
    user_id = current_user.id

    hashtag_string = params[:hashtag]
    # hashtags are being validated and preprocessed on the client side
    hashtags = hashtag_string.split(" ")
    question_hashtags = []
    hashtags.each do |hashtag|
      question_hashtags.push(Hashtag.find_or_create_by_name(hashtag))
    end

    @question = Question.create(params[:question].merge(:score => 0, :user_id => user_id))
    follow = Follow.create(:user_id => current_user.id, :question_id => @question.id)
    respond_to do |format|
      if @question.save
        # add asscociations only if question is saved successfully
        question_hashtags.each do |h|
          @question.hashtags << h
        end
        # when user creates a question, he/she is automatically following that question
        follow.save

        #Add the current_user to notification table
        #notification = InitiatorNotification.create(:user_id => current_user.id, :question_id => @question.id, :read => false)
        #notification.save
        #Redirect to the question OR back to questions page?
        format.html { redirect_to @question }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.json { render json: @question.errors, status: :unprocessable_entity}
      end
    end
  end

#Display a specific question
#Requires: Question ID
#Modifies: Nothing
#Effects: Renders the question with that ID
  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.order('score DESC')
    @answer = @question.answers.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => {"question" => @question, "answers"=> @answers} }
    end

  end


#Updates a specific question
#Requires: Question ID, Question Title, Question Content
#Modifies: Question Table
#Effects: Updates question in Question table with that ID
  def update
    @question = current_user.questions.find(params[:id])
    is_anon = @question.is_anon
    # notify all the followers of this question
    follows = Follow.where(:question_id => params[:id])
    follows.each do |f|
      EditQuestionNotification.create(:user_id => f.user_id, :question_id => params[:id], :read => false, :modifier_id => current_user.id, :question_title => @question.title,  :is_anon => is_anon)
    end

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.json { head :no_content }
      else
        format.json { render json: @question.errors }
      end
    end
  end

#Deletes a specific question
#Requires: Question ID
#Modifies: Question Table
#Effects: Remove question from Question table with that ID
  def destroy
    @question = current_user.questions.find(params[:id])

    is_anon = @question.is_anon
    # notify all the followers of this question
    follows = Follow.where(:question_id => params[:id])
    follows.each do |f|
      DeleteQuestionNotification.create(:user_id => f.user_id, :question_id => params[:id], :read => false, :modifier_id => current_user.id, :question_title => @question.title, :is_anon => is_anon)
    end

    @question.destroy
    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to main_path, :notice => "Your question has been deleted." }
    end
  end

#Refer a friend to answer a question
#Requires: valid email, qid, request, logged in user.
#Modifies: nothing
#Effects: Sends an email on behalf of the current user to the email address given.
#	  This email will request that the user answers the particular question.
  def request_send_email
    if UserMailer.request_answer_email(params[:email], params[:qid], params[:request], current_user).deliver
      flash[:notice] = "Successfully sent email!"
      redirect_to :action => "show", :id => params[:qid]
    else
      flash[:notice] = "Something went wrong while attempting to send your request."
      redirect_to :action => "show", :id => params[:qid]
    end
  end

end
