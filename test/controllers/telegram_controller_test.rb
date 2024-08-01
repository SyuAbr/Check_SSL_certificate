require "test_helper"

class TelegramControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get telegram_new_url
    assert_response :success
  end

  test "should get create" do
    get telegram_create_url
    assert_response :success
  end
end
