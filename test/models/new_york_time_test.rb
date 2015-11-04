require 'test_helper'

class NewYorkTimeTest < ActiveSupport::TestCase
  test "should not return a nil data" do
    news = NewYorkTime.get_business_news
    assert_not(news.nil?) # must not be nil
  end
end
