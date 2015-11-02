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
  def format_number(market_cap)
    number_to_human(market_cap, precision: 4, units: {million: "M", billion: "B"}).split(" ").join("") # get rid of spacing in between
  end
end
