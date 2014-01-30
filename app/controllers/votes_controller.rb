class VotesController < ApplicationController
  before_filter :find_vote, :only => [:upvote, :downvote]

  # Requires: logged in user and either question_id or answer_id
  # Modifies: Votes and (Questions xor Answers)
  # Effects: Updates the score of the Vote object and the
  #          Post object.
  def upvote
    if @vote.score == 1 #currently upvote
      @vote.update_attributes(:score => 0)
      @post.updateScore(-1)
      render :text => "0"

    elsif @vote.score == 0 #currently no vote
      @vote.update_attributes(:score => 1)
      @post.updateScore(1)
      if @post.instance_of?(Question)
        # notify all the followers of this question
        follows = Follow.where(:question_id => @post.id)
        follows.each do |f|
          UpvoteQuestionNotification.create(:user_id => f.user_id, :question_id => @post.id, :read => false, :modifier_id => current_user.id, :question_title => @post.title, :is_anon => false)
        end
      end
      render :text => "1"

    else #currently down vote
      @vote.update_attributes(:score => 1)
      @post.updateScore(2)
      render :text => "1"
    end
  end

  # Requires: logged in user and either question_id or answer_id
  # Modifies: Votes and (Questions xor Answers)
  # Effects: Updates the score of the Vote object and the
  #          Post object.
  def downvote
    if @vote.score == 1 #currently upvote
      @vote.update_attributes(:score => -1)
      @post.updateScore(-2)
      render :text => "-1"

    elsif @vote.score == 0 #currently no vote
      @vote.update_attributes(:score => -1)
      @post.updateScore(-1)
      render :text => "-1"
      if @post.instance_of?(Question)
        # notify all the followers of this question
        follows = Follow.where(:question_id => @post.id)
        follows.each do |f|
          DownvoteQuestionNotification.create(:user_id => f.user_id, :question_id => @post.id, :read => false, :modifier_id => current_user.id, :question_title => @post.title, :is_anon => false)
        end
      end

    else #currently downvote
      @vote.update_attributes(:score => 0)
      @post.updateScore(1)
      render :text => "0"
    end
  end

  # Requires: logged in user and either question_id or answer_id
  # Modifies: Votes
  # Effects: Determines if we are dealing with a Question or an
  #          Answer and sets the post variable accordingly. Sets
  #          the vote through the checkVote method.
  protected
  def find_vote
    if params[:question_id]
      @post = Question.find(params[:question_id])
    else
      @post = Answer.find(params[:answer_id])
    end

    @vote = Vote.checkVote(current_user.id, params[:question_id], params[:answer_id])
  end
end
