class FollowsController < ApplicationController

#Return HTML form for creating a new follow object
#Requires: Nothing
#Modifies: Nothing
#Effects: Renders page for creating a new follow association
  def new
    @follow = Follow.new
  end

#Create/Delete a follow
#Requires: user is logged in, question they follow toggling exists
#Modifies: Follows
#Effects: Either creates or deletes a follow object from the Follows table
  def toggle
    @follows = Follow.where(:user_id => current_user.id, :question_id => params[:question]).all
    if !@follows.empty?
      @follows.each do |follow|
        follow.destroy
      end
      render :text => 'Successfully destroyed Follow association'
    else
      @follow = Follow.create(:user_id => current_user.id, :question_id => params[:question])
      render :text => 'Successfully created Follow association'
    end
  end
end

