require "test_helper"

class LoggerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get logger_index_url
    assert_response :success
  end
end
