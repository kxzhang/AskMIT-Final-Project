require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  
  setup do
     session[:user_id] = users(:Kelly).id
     session[:expires_at] = Time.now + 120.minutes
     
     @Answer = {
          content: "Any of the libraries. Also, people are always sleeping outside of 26-100 so it must be a good spot.",
          user_id: 4,
          score: 0,
          is_anon: false
      }     
  end

  test "create new answer" do
    assert_difference('Answer.count', 1) do
       post :create, :answer => @Answer, :question_id => 1,
    end
  end

  test "update existing answer" do
    put :update, :id => answers(:Answer1), :answer => {:content => 'content changed'}
    assert_equal 'content changed', Answer.find(answers(:Answer1).id).content
  end

  test "delete answer" do
    assert_difference('Answer.count', -1) do
       delete :destroy, id: answers(:Answer1)
    end
  end
  
end
