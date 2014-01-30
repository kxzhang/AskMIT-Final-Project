require 'test_helper'

class MainControllerTest < ActionController::TestCase

  test "should get index" do
    session[:user_id] = users(:Helen).id
    session[:expires_at] = Time.now + 120.minutes
    get :index
    assert_response :success
    assert_equal(4, assigns['hashtags'].size, "must have 4 hashtags")
  end

  test "should redirect" do
    get :index
    assert_response :redirect
  end
end
