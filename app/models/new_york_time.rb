class NewYorkTime
  BUSINESS_NEWS_ENDPOINT='https://api.nytimes.com/svc/topstories/v2/business.json?api-key='

  def self.get_business_news
    response = HTTParty.get("#{BUSINESS_NEWS_ENDPOINT}#{ENV['NY_KEY']}")
    data_to_json = JSON.parse(response.body, symbolize_names: true)[:results]
    # sort news array [latest ... oldest]
    data_to_json.sort { |data1, data2| Time.parse(data2[:created_date]).to_i <=> Time.parse(data1[:created_date]).to_i }
  end
end
