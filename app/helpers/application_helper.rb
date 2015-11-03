module ApplicationHelper
  # this helper gives the full page title on a per page basis
  def full_title(page_title="")
    base_title = "Learn to Trade with PaperTrading"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # modified number_to_human helper method
  # http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html
  def format_number(num)
    number_to_human(num, precision: 4, units: { million: "M", billion: "B" }).split(" ").join("") # get rid of spacing in between
  end

  # market cap of a stock
  # calculate market cap of a queried data (get_quote)
  def market_cap(data)
    # market cap = share outsanding times last price of quote
    market_cap = data[:sho].gsub(",","").to_i * data[:last].to_f
    format_number(market_cap)
  end
end
