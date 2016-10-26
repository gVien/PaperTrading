class SearchesController < ApplicationController
  def show_stock_not_found
  end

  def show
    @query = params[:symbol]
    @stock = Stock.search(@query)
    if @stock.respond_to?(:each) #duck typing
      render "show_stocks_list"
    else
      if @stock
        redirect_to @stock
      else
        render "show_stock_not_found"
      end
    end
  end
end
