class TradeKing < ActiveRecord::Base
  class << self
    def get_quote(sym)
      # available quote options at https://developers.tradeking.com/documentation/market-ext-quotes-get-post
      quote = get("/v1/market/ext/quotes.json", sym)
      format(quote)
    end

    def get_toplosers
      toplosers = get('/v1/market/toplists/toplosers.json')
      format(toplosers)
    end

    def get_top_pct_losers
      toppctlosers = get('/v1/market/toplists/toppctlosers.json')
      format(toppctlosers)
    end

    def get_topvolume
      topvolume = get('/v1/market/toplists/topvolume.json')
      format(topvolume)
    end

    def get_topactive
      topactive = get('/v1/market/toplists/topactive.json')
      format(topactive)
    end

    def get_topgainers
      topgainers = get('/v1/market/toplists/topgainers.json')
      format(topgainers)
    end

    def get_top_pct_gainers
      toppctgainers = get('/v1/market/toplists/toppctgainers.json')
      format(toppctgainers)
    end

    def get_top_active_gainers_by_dollar_value
      top_by_dollar = get('/v1/market/toplists/topactivegainersbydollarvalue.json')
      format(top_by_dollar)
    end


  private
    def oauth
      # Set up an OAuth Consumer
      consumer = OAuth::Consumer.new credentials[:consumer_key], credentials[:consumer_secret], { :site => 'https://api.tradeking.com' }

      # Manually update the access token/secret.  Typically this would be done through an OAuth callback when
      # authenticating other users.
      OAuth::AccessToken.new(consumer, credentials[:access_token], credentials[:access_token_secret])
    end

    def credentials
      {
        :consumer_key        => ENV["TK_CONSUMER_KEY"],
        :consumer_secret     => ENV["TK_CONSUMER_SECRET"],
        :access_token        => ENV["TK_ACCESS_TOKEN"],
        :access_token_secret => ENV["TK_ACCESS_TOKEN_SECRET"]
      }
    end

    def get(endpoint, sym = nil)
      if sym
        oauth.get(endpoint + "?symbols=#{sym}", {'Accept' => 'application/json'}).body
      else
        oauth.get(endpoint, {'Accept' => 'application/json'}).body
      end
    end

    def format(data)
      JSON.parse(data, symbolize_names: true)[:response][:quotes][:quote]
    end
  end
end