require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Baseball Lovers"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Baseball Lovers"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | Baseball Lovers"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Baseball Lovers"
  end
end