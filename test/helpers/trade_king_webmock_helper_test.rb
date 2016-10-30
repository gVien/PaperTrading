module TradeKingWebmockHelperTest
  def stub_get_quote_request(symbol)
    stub_request(:get, "https://api.tradeking.com/v1/market/ext/quotes.json?symbols=YHOO")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/trade_king/get_quote.json')))
  end

# change endpoint and create json file 

  def stub_get_toplosers
    stub_request(:get, "https://api.tradeking.com/v1/market/ext/quotes.json?symbols=YHOO")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/trade_king/get_toplosers.json')))
  end


  def stub_get_top_pct_losers
    stub_request(:get, "https://api.tradeking.com/v1/market/ext/quotes.json?symbols=YHOO")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/trade_king/get_top_pct_losers.json')))
  end


  def stub_get_topvolume
    stub_request(:get, "https://api.tradeking.com/v1/market/ext/quotes.json?symbols=YHOO")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/trade_king/get_topvolume.json')))
  end


  def stub_get_topactive
    stub_request(:get, "https://api.tradeking.com/v1/market/ext/quotes.json?symbols=YHOO")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/trade_king/get_topactive.json')))
  end


  def stub_get_topgainers
    stub_request(:get, "https://api.tradeking.com/v1/market/ext/quotes.json?symbols=YHOO")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/trade_king/get_topgainers.json')))
  end

  def stub_get_top_pct_gainers
    stub_request(:get, "https://api.tradeking.com/v1/market/ext/quotes.json?symbols=YHOO")
      .to_return(status: 'OK',
                 body: File.open(File.join(Rails.root, 'test/fixtures/trade_king/get_top_pct_gainers.json')))
  end
end
