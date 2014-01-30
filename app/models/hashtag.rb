class Hashtag < ActiveRecord::Base
  # Accessible Attributes
  attr_accessible :name, :last_used

  # Associations
  has_and_belongs_to_many :questions

  # Validations
  validates :name, :uniqueness => { :case_sensitive => false }

  # Model Methods
end

