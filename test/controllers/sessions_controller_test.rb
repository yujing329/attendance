require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    get login_path  #8.3: Sessionsコントローラのテストで名前付きルートを使うようにする
    assert_response :success
  end
end