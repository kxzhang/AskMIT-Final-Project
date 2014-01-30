class Answer < ActiveRecord::Base
  # Accessible Attributes
  attr_accessible :content, :question_id, :created_at, :user_id, :score, :is_anon

  # Associations
  belongs_to :user
  belongs_to :question

  # Validations

  # Model Methods
  def updateScore(score_change)
    new_score = self.score + score_change
    self.update_attributes(:score => new_score)
  end
end

