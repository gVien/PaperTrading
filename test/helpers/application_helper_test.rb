require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  def setup
    @stock_data = { sho: "1,000,000",
                    last: 2.5 }
  end

  test "full title helper" do
    assert_equal full_title, "Learn to Trade with PaperTrading"
    assert_equal full_title("Contact Us"), "Contact Us | Learn to Trade with PaperTrading"
  end

  test "format number method" do
    # less than 1 million
    assert_equal format_number("123456"), "123500"
    assert_equal format_number("12"), "12"

    # more than 1M, less than 1B
    assert_equal format_number("1234567"), "1.235M"
    assert_equal format_number("98765432"), "98.77M"
    assert_equal format_number("987654321"), "987.7M"

    # >= 1B
    assert_equal format_number("9876543210"), "9.877B"
    assert_equal format_number("98765432100"), "98.77B"
  end

  test "market_cap method should calculate correct market capitalization of a stock" do
    market_cap = @stock_data[:sho] * @stock_data[:last] #=> 2.5M
    assert_equal market_cap(@stock_data), "2.5M"
  end
end