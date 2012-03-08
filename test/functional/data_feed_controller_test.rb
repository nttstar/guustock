require 'test_helper'

class DataFeedControllerTest < ActionController::TestCase
  test "should get bar" do
    get :bar
    assert_response :success
  end

end
