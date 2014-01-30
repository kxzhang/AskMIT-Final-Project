class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :confirm, :create]

  def new
    @user = User.new
  end

  # renders user profile page according to whether the
  # viewer is user himself/herself
  def show
    @user = User.find(params[:id])
    @questions = []
    @answers = []
    # if current_user is viewing his or her profile
    # show all questions and answers regardless of
    # anonymity. Otherwise only fetch public posts
    if current_user.id == @user.id
      @questions = current_user.questions
      @user.answers.each do |ans|
        @answers << Question.find(ans.question_id)
      end
    else
      @questions = @user.questions.where(:is_anon => false)
      @user.answers.each do |ans|
        q = Question.find(ans.question_id)
        if !ans.is_anon?
          @answers << q
        end
      end
    end

    @follows = []
    user_follows = Follow.where(:user_id => @user.id)
    user_follows.each do |fol|
      if Question.exists?(fol.question_id)
        @follows << Question.find(fol.question_id)
      end
    end
  end


  # creates an unconfirmed user with a one-time token
  # requires: username must be unique and password is not none
  # modifies: creates a user
  def create
    @user = User.new(params[:user].merge(:token => SecureRandom.base64(10), :confirm => false))
    if @user.save
      if UserMailer.confirmation_email(@user).deliver
        render :confirm_message
      else
        @user.destroy
      end
    else
      # display only one error per field
      if @user.errors.any?
        @user.errors.each do |key, value|
          if key.equal?(:email)
            @email_error = value
          elsif key.equal?(:first_name)
            @first_name_error = value
          elsif key.equal?(:last_name)
            @last_name_error = value
          elsif key.equal?(:password)
            @password_error = value
          elsif key.equal?(:password_confirmation)
            @password_confirmation_error = value
          end
        end
      end
      render "new"
    end
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # confirms a user with a token, and erase the token if successful.
  def confirm
    user = User.find_by_email(params[:email])
    # make sure user do not use the string "used" to hack the system
    if user.token != "used" && params[:token] == user.token
      user.confirm = true
      user.token = "used"  #token is only for one time use
      if user.save
        session[:user_id] = user.id
        redirect_to main_path
      end
    else
      render :text => "You have confirmed before. Or something went wrong"
    end
  end
end
