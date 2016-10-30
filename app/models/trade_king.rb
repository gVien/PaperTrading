class TradeKing
  TRADE_KING_BASE_URL  = 'https://api.tradeking.com/'

  GET_QUOTE_ENDPOINT = '/v1/market/ext/quotes.json'
  def get_quote(sym)
    quote = get(GET_QUOTE_ENDPOINT, sym)
    format_json(quote)
  end

  GET_TOPLOSERS_ENDPOINT = '/v1/market/toplists/toplosers.json'
  def get_toplosers
    toplosers = get(GET_TOPLOSERS_ENDPOINT)
    format_json(toplosers)
  end

  GET_TOP_PCT_LOSERS = '/v1/market/toplists/toppctlosers.json'
  def get_top_pct_losers
    toppctlosers = get(GET_TOP_PCT_LOSERS)
    format_json(toppctlosers)
  end

  GET_TOPVOLUME = '/v1/market/toplists/topvolume.json'
  def get_topvolume
    topvolume = get(GET_TOPVOLUME)
    format_json(topvolume)
  end

  GET_TOPACTIVE = '/v1/market/toplists/topactive.json'
  def get_topactive
    topactive = get(GET_TOPACTIVE)
    format_json(topactive)
  end

  GET_TOPGAINERS = '/v1/market/toplists/topgainers.json'
  def get_topgainers
    topgainers = get(GET_TOPGAINERS)
    format_json(topgainers)
  end

  GET_TOP_PCT_GAINERS = '/v1/market/toplists/toppctgainers.json'
  def get_top_pct_gainers
    toppctgainers = get(GET_TOP_PCT_GAINERS)
    format_json(toppctgainers)
  end

  # private_class_method :oauth, :credentials, :get, :format_json
  def oauth
    # Set up an OAuth Consumer
    consumer = OAuth::Consumer.new(credentials[:consumer_key],
                                   credentials[:consumer_secret],
                                   { :site => TRADE_KING_BASE_URL })

    # Manually update the access token/secret.  Typically this would be done through an OAuth callback when
    # authenticating other users.
    OAuth::AccessToken.new(consumer,
                           credentials[:access_token],
                           credentials[:access_token_secret])
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
      oauth.get("#{endpoint}?symbols=#{sym}", {'Accept' => 'application/json'}).body
    else
      oauth.get(endpoint, {'Accept' => 'application/json'}).body
    end
  end

  def format_json(data)
    response = JSON.parse(data, symbolize_names: true)
    if response[:response][:message] == "An error has occurred while processing your request."
      response
    else
      response[:response][:quotes][:quote]
    end
  end
end
