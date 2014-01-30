class Vote < ActiveRecord::Base
  # Accessible Attributes
  attr_accessible :score, :question_id, :answer_id

  # Associations
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  # Validations

  # Model Methods
  
  # Requires: A user_id and either a question_id or an answer_id
  # Modifies: Nothing
  # Effects: Returns either the existing vote object
  # for the user for the q/a, or a new Vote object
  def self.checkVote(user_id, q_id, a_id)
    if a_id # Yes answer_id: dealing with answer
      if User.find(user_id).votes.find_by_answer_id(a_id) # Vote object exists
        return User.find(user_id).votes.find_by_answer_id(a_id)
      else # Vote object doesn't exist
        return User.find(user_id).votes.create(:score => 0, :answer_id => a_id)
      end

    else # No answer_id: dealing with question
      if User.find(user_id).votes.find_by_question_id(q_id) # Vote object exists
        return User.find(user_id).votes.find_by_question_id(q_id)
      else # Vote object doesn't exist
        return User.find(user_id).votes.create(:score => 0, :question_id => q_id)
      end
    end
  end
end
