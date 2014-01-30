require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
 
  setup do
     session[:user_id] = users(:Kelly).id
     session[:expires_at] = Time.now + 120.minutes
     
     @valid_question = {
          details: "Harvard has them :(",
          title: "Why do we not have dead week?",
          user_id: 1,
          score: 0,
          is_anon: true
      }
  end

  test "create new question page" do
    get :new
    assert_response :success
  end

  test "create new question success" do
    assert_difference('Question.count', 1) do
       post :create, :question => @valid_question, :hashtag => 'aa bb'
    end
    assert_response :redirect
  end

  test "update existing question" do
    put :update, :id => questions(:Question1), :question => {:title => 'title change'}
    assert_equal 'title change', Question.find(questions(:Question1).id).title
  end

  test "delete question" do
    assert_difference('Question.count', -1) do
       delete :destroy, id: questions(:Question1)
    end
  end
end
