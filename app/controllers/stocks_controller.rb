class StocksController < ApplicationController
  def show
    @stock = Stock.find_by_symbol(params[:id])  # id from redirect
    if @stock
      @stock
    else
      redirect_to search_path(symbol: params[:id].upcase)
    end
  end
end
