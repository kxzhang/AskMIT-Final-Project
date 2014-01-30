require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = users(:Helen).id
  end

  test "should destroy" do
    get :destroy
    assert_response :redirect
    assert_nil session[:user_id]
  end

end
