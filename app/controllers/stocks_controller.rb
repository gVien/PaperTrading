class StocksController < ApplicationController
  def show
    @stock = Stock.find(params[:id])  # id from redirect
  end
end
