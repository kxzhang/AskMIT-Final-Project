class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]
  def new
  end

  # creates a new session
  # requires: valid username and password
  # effects: creates a new session which expires in two hours
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password]) && user.confirm
      session[:user_id] = user.id
      session[:expires_at] = Time.now + 120.minutes
      redirect_to main_url
    else
      flash[:error] = "Invalid username or password"
      render "new"
    end
  end

  # destroys a session
  # effects: redirect user to posts listing page
  def destroy
    session[:user_id] = nil
    flash[:error] = "You are successfully logged out"
    redirect_to root_url
  end
end
