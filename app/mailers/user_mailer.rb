class UserMailer < ActionMailer::Base
  default from: "askmitinfosquad@gmail.com" #replace this
  def confirmation_email(user)
    @user = user
    @url = confirm_path(:email => user.email, :token => user.token)
    mail(:to=> user.email, :subject => "Welcome to Ask@MIT")
  end

  def request_answer_email(email, qid, text, user)
    @userfrom = user
    @text = text
    @q_id = qid
    mail(:to=> email, :subject => "Answer question request")
  end
end
