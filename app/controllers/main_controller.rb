class MainController < ApplicationController

  # Requires: User must be logged in
  # Modifies: Nothing
  # Effects: Displays a list of most popular questions.
  def index
    # for "new question" form
    @question = Question.new
    # Obtains the 20 most recently used Hashtags
    @hashtags = Hashtag.order('last_used DESC').limit(20)

    # note: a list of questions is fetched by the client side when document is ready
  end

  # Requires: User must be looged in
  # Modifies: Nothing
  # Effects: Returns a list of questions according to the sorting param
  def sort
    # ref: https://github.com/amatsuda/kaminari/wiki/How-To:-Create-Infinite-Scrolling-with-jQuery
    # note: I did not use sausage.
    if params[:by] == "recent"
      @questions = Question.order('created_at DESC').page(params[:page]).per(5)

      # fetch all the questions that the user is following
    elsif params[:by] == "follow"
      @follows = Follow.where(:user_id => current_user.id).all
      @questions = []
      @follows.each do |follow|
        if Question.exists?(follow.question_id)
          @questions << Question.find(follow.question_id)
        end
      end
      @questions = Kaminari.paginate_array(@questions).page(params[:page]).per(5)
      # default to fetch all questions posted within the past month, ordered by highest score first
    else
      @questions = Question.where(["created_at >= ?", 1.month.ago]).order('score DESC').page(params[:page]).per(5)
    end

    render json: {
        'action' => 'recent',
        'html' => render_to_string(:partial => '/questions/viewquestion', :collection => @questions)
    }
  end

  # Requires: User must be logged in
  # Modifies: Nothing
  # Effects: searches question title and body against query param,
  # and returns a list of matching questions
  def search
    if params[:use_highlights]
      @questions = Question.highlight_tsearch(params[:q])
    else
      @questions = Question.plain_tsearch(params[:q])
    end

    if @questions.any?
      render :results
    else
      render :no_results
    end
  end

  def word_cloud
  end

  # for auto-complete feature
  # requires: User has logged in
  # modifies: none
  # effects:fetches a list of question titles as a json array
  def question_titles
    @question_titles = Question.select("id, title").all;
    render :json => @question_titles
  end

  # for auto-complete feature
  # requires: User has logged in
  # modifies: none
  # effects:fetches a list of hashtags as a json array
  def hashtag_names
    @hashtags = Hashtag.where('lower(name) like lower(?)', "%#{params[:filter]}%").select("name").all;
    render :json => @hashtags
  end

end
