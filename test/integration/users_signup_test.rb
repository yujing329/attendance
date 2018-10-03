require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "valid signup information" do  # 7.33: 有効なユーザー登録に対するテスト
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                        email: "user@example.com",
                                        password:              "password",
                                        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?  #8.27: ユーザー登録後のログインのテスト
  end
end