require "test_helper"

class PeoplesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get peoples_show_url
    assert_response :success
  end
end
