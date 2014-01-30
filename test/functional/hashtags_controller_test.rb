require 'test_helper'

class HashtagsControllerTest < ActionController::TestCase

  setup do
    session[:user_id] = users(:Helen).id
    session[:expires_at] = Time.now + 120.minutes
  end

  test "get view" do
    get :view, :name => "napping"
    assert_response :redirect
  end


  test "get sort" do
    get :sort, :id => 1, :by => 'recent'
    assert_response :success
    assert_equal(assigns['questions'].size, 0, "size not right")

  end


  test "get cloud" do
    get :wordcloud
    assert_response :success
    assert_equal(assigns['hashtags'].size, 4, "size not right")
  end


end
