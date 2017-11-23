class DataController < ApplicationController
  def historical_daily
    @symbol = params[:symbol]
    @currency = params[:currency] || 'usd'

    coin = Coin.select(:id).find_by_symbol(@symbol)
    @prices = coin.daily_prices.for_currency(@currency)
    @news = coin.articles.chart_data
  end

  def historical_hourly
    @symbol = params[:symbol]
    @results = HistoHour.where(from_symbol: @symbol.upcase).order(time: :asc)
    @volume = @results.pluck(:volumefrom)
    @prices = @results.pluck(:time, :open, :high, :low, :close)
    @prices = @prices.each do |price|
      price[0] = price[0] * 1000
    end
  end
end
