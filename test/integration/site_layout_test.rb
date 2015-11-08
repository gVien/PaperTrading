require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template "static_pages/home"
    # the question mark is replaced by the path url inside a[...]
    # e.g. <a href="/about"> ... </a>
    # for the root path, it verifies two links (one for the logo and navigation menu element)
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "title", full_title("Welcome")
    # added sign up form for users, so testing it here
    get signup_path
    assert_select "title", full_title("Sign up")
  end
end
