# represents an abstract notification object
# @params :
# question_id, id of the question thread which has new action
# user_id, id of the user who made change to the question thread(i.e responded with an answer)
# read, boolean specifying whether the notification is read
class Notification < ActiveRecord::Base
  attr_accessible :question_id, :user_id, :read, :type, :modifier_id, :question_title, :is_anon
end
