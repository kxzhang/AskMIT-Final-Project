require 'test_helper'

class VotesControllerTest < ActionController::TestCase
#  test "should get upvote" do
#    get :upvote
#    assert_response :success
#  end

#  test "should get downvote" do
#    get :downvote
#    assert_response :success
#  end

  test "upvote" do
    post :upvote, {:question_id => 1}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    assert_equal assigns["vote"].score, 1
  end

  test "downvote" do
    post :downvote, {:question_id => 2}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    assert_equal assigns["vote"].score, -1
  end

  test "double downvote" do
    post :downvote, {:question_id => 3}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    post :downvote, {:question_id => 3}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    assert_equal assigns["vote"].score, 0
  end

  test "double upvote" do
    post :upvote, {:question_id => 4}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    post :upvote, {:question_id => 4}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    assert_equal assigns["vote"].score, 0
  end

  test "downvote then upvote" do
    post :downvote, {:question_id => 4}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    post :upvote, {:question_id => 4}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    assert_equal assigns["vote"].score, 1
  end
end
