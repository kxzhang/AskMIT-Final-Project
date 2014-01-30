class AnswersController < ApplicationController

# create an answer to a question
# requires: user is authenticated, question id param
# modifies: answers
# effects: answer is created
  def create
    user_id = current_user.id

    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(params[:answer].merge(:score => 0, :user_id => user_id))

    is_anon = params[:answer][:is_anon]
    # notify all the followers of this question
    follows = Follow.where(:question_id => params[:question_id])
    follows.each do |f|
      NewAnswerNotification.create(:user_id => f.user_id, :question_id => params[:question_id], :read => false, :modifier_id => current_user.id, :question_title => @question.title, :is_anon => is_anon)
    end

    respond_to do |format|
      if @answer.save
        # render the answer in json
        format.json { render json: @answer, status: :created, location: @answer }
        format.js
      else
        # render errors in json
        format.json { render json: @answer.errors, status: :unprocessable_entity}
      end
    end
  end

# PUT /answers/1
# modify an existing answer
# requires: user is authenticated, answer belongs to user
# modifies: answers
# effects: answer's attributes are updated
  def update
    @answer = current_user.answers.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.json { head :no_content }
      else
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /answers/1
# DELETE /answers/1.json
# delete an answer
# requires: user is authenticated, answer belongs to user
# modifies: answers
# effects: answer is deleted
  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

end
