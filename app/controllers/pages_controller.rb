class PagesController < ApplicationController
  RSS_URL = 'http://admin.coinfi.com/rss/'.freeze

  def home
    render layout: false
  end

  def about
  end

  def contact
  end

  def daily
    # TODO: Add caching!
    xml = HTTParty.get(RSS_URL).body
    feed = Feedjira::Feed.parse xml
    entry = feed.entries.first
    @title = entry.title
    @content = entry.content.html_safe
  end

  def customize
    # NOTE: These tags must exist already in ConvertKit!
    #
    @maincoins = {
      'BTC' => 'Bitcoin',
      'ETH' => 'Ethereum',
      'LTC' => 'Litecoin'
    }
    @altcoins = {
      'BCC' => 'Bitcoin Cash',
      'XRP' => 'Ripple',
      'XEM' => 'NEM',
      'DASH' => 'DASH',
      'IOTA' => 'MIOTA',
      'XMR' => 'Monero',
      'NEO' => 'NEO'
    }
    @exchanges = ['Bitfinex', 'GDAX', 'Bittrex', 'Kraken', 'Poloniex']
  end

  def segment
    # Grab cookie with stored email address
    email = cookies[:coinfi_email]

    byebug

    # Add subscriber to tag
    client = Convertkit::Client.new

    params[:preferences].each do |tag|
      client.add_subscriber_to_tag(tag_id, email, options = {})
    end

    redirect_to :thanks
  end

  def thanks

  end
end
