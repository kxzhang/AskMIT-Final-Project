class HashtagsController < ApplicationController

  # Views specified hashtag
  # Requires: hashtag name
  # Modifies: none
  # Effects: Shows the specified hashtag
  def view
    hashtag_id = Hashtag.where(:name => params[:name]).first.id
    redirect_to hashtag_path(hashtag_id)
  end


  # show all questions that are categorized by this hashtag
  # requires: hashtag id param defined
  # modifies: none
  # effects: renders list of all questions categorized under specified hashtag
  def show
    @hashtag = Hashtag.find_by_id(params[:id])
    @question = @hashtag.questions.new
    @hashtags = Hashtag.order('last_used DESC').limit(20)

    render 'main/index'
  end

  # fetch questions of this hashtag ordered based on the 'by' param
  # requires: id param, param 'by' indicating what to sort by
  # modifies: none
  # effects: Displays questions ordered based on given 'by' param
  def sort
    @hashtag = Hashtag.find_by_id(params[:id])

    # ref: https://github.com/amatsuda/kaminari/wiki/How-To:-Create-Infinite-Scrolling-with-jQuery
    # note: I did not use sausage.
    if params[:by] == "recent"
      @questions = @hashtag.questions.order('created_at DESC').page(params[:page]).per(5)

    elsif params[:by] == "follow"
      @follows = Follow.where(:user_id => current_user.id).all
      @questions = []
      @follows.each do |follow|
        question = @hashtag.questions.find_by_id(follow.question_id)
        unless question.blank?
          @questions << question
        end
      end
      @questions = Kaminari.paginate_array(@questions).page(params[:page]).per(5)
    else  # default popular
      @questions = @hashtag.questions.where(["created_at >= ?", 1.month.ago]).order('score DESC').page(params[:page]).per(5)
    end

    render json: {
        'action' => 'recent',
        'html' => render_to_string(:partial => '/questions/viewquestion', :collection => @questions)
    }
  end

  # get all hashtags for the word cloud 
  # Requires: none
  # Modifies: none
  # Effects: Generates word cloud filled with all hashtags 
  def wordcloud
    @hashtags = []
    count = 0
    Hashtag.all.each do |h|
      @hashtags.append({:tag => h.name, :count => h.questions.count})
      count += h.questions.count
    end

    gon.tag_list = @hashtags
    gon.total_weight = count

  end
end
