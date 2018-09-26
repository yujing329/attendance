require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")  #リスト 6.39
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do            #6.7: name属性にバリデーションに対するテスト
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do           #6.11: email属性の検証に対するテスト
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do       #6.14: nameの長さの検証に対するテスト
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do      #6.14: emailの長さの検証に対するテスト
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do     #6.18: 有効なメールフォーマットをテスト
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do   #6.19: メールフォーマットの検証に対するテスト
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do  #6.24: 重複するメールアドレス拒否のテスト
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase #6.26: 大文字小文字を区別しない、一意性のテスト
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do #6.33: リスト 6.32のメールアドレスの小文字化に対するテスト
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do           #6.41: パスワードの最小文字数をテスト
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do           #6.41: パスワードの最小文字数をテスト
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end