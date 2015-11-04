class NewYorkTime

  def self.get_business_news
    response = HTTParty.get("http://api.nytimes.com/svc/topstories/v1/business.json?api-key=#{ENV['NY_KEY']}")
    JSON.parse(response.body, symbolize_names: true)[:results]
  end
end
