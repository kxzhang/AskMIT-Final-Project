require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = users(:Helen).id
    session[:expires_at] = Time.now + 120.minutes
  end

  test "get profile page" do
    get :show, :id=> users(:Helen).id
    assert_response :success
  end

end
