require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Baseball Lovers"
    assert_equal full_title("Help"), "Help | Baseball Lovers"
  end
end