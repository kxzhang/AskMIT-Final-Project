require 'test_helper'

class FollowsControllerTest < ActionController::TestCase
  test "toggle once" do
    post :toggle, {:question => 1}, {:user_id => 1, :expires_at => Time.now + 120.minutes}, nil
    assert_not_nil assigns["follow"]
  end
end
