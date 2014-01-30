require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase

  setup do
    session[:user_id] = users(:Helen).id
    session[:expires_at] = Time.now + 120.minutes
  end

  test "get index" do
    get :index
    assert_response :success
    assert assigns['notifications'].size == 4
  end

  test "mark read" do
    get :mark_read
    assert_response :success
    assert notifications(:n1).read
  end

  test "new notifications" do
    get :new_notifications
    assert_response :success
    assert assigns["new_notifications"].size == 2
  end
end
