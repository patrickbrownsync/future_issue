require 'test_helper'

class LiveControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get live_test_url
    assert_response :success
  end

end
