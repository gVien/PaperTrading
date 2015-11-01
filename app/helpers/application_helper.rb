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
end
