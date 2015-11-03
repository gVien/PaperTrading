require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @base_title = "Learn to Trade with PaperTrading"
  end

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Welcome | #{@base_title}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About PaperTrading | #{@base_title}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact Us | #{@base_title}"
  end
end
