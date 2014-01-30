class User < ActiveRecord::Base
  # Accessible Attributes
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :confirm, :token, :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  has_secure_password

  # Associations
  has_many :questions , :dependent => :destroy
  has_many :answers, :dependent => :destroy
  has_many :votes, :dependent => :destroy

  # Validations
  validates_presence_of :email, :on => :create
  validates_presence_of :first_name, :on => :create
  validates_presence_of :last_name, :on => :create
  validates :password, :presence => true,
            :confirmation => true,
            :length => {:within => 6..40},
            :on => :create
  validates :password, :confirmation => true,
            :length => {:within => 6..40},
            :allow_blank => true,
            :on => :update
  # email regex for MIT emails
  emailRegex = /\A([^@\s]+)@(([-a-z0-9]+)\.)?(mit)\.(edu)\Z/i    #eg. name@mit.du and name@csail.mit.edu
  validates_format_of :email, :on => :create, :with => emailRegex, :message => "is not a valid MIT email"
  validates_uniqueness_of :email


  def isFollowing(q_id)
    follows = Follow.where(:question_id => q_id, :user_id => self.id)
    return !follows.empty?
  end
  # Model Methods
  def get_question_score(q_id)
    question = self.votes.find_by_question_id(q_id)
    if question
      return question.score
    else
      return false
    end
  end

  def get_answer_score(a_id)
    answer = self.votes.find_by_answer_id(a_id)
    if answer
      return answer.score
    else
      return false
    end
  end
end
