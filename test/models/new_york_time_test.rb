require 'test_helper'

class NewYorkTimeTest < ActiveSupport::TestCase
  test "should not return a nil data" do
    stub_new_york_time_business_new
    news = NewYorkTime.get_business_news
    assert_not(news.nil?) # must not be nil
  end

  private def stub_new_york_time_business_new
    stub_request(:get, "#{NewYorkTime::BUSINESS_NEWS_ENDPOINT}#{ENV['NY_KEY']}")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/new_york_time/new_york_time.json')))
  end
end
