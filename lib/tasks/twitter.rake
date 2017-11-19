require 'twitter'

TICKERS = %w(
  $BTC
  $ETH
  $BCC
  $XRP
  $LTC
  $DASH
  $NEO
  $IOTA
  $XMR
  $NEM
).freeze

keywords = ENV.fetch('TWITTER_SCAN_KEYWORDS', '').split(',')

namespace :twitter do
  task :scan => :environment do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch("TWITTER_CONSUMER_KEY")
      config.consumer_secret     = ENV.fetch("TWITTER_CONSUMER_SECRET")
      config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
      config.access_token_secret = ENV.fetch("TWITTER_ACCESS_SECRET")
    end

    TICKERS.each do |ticker|
      puts "Scanning #{ticker} on Twitter..."
      client.search("#{ticker}", result_type: "recent").take(50).collect do |tweet|
        if keywords.any? { |keyword| tweet.text.downcase.include? keyword }
          puts tweet.id, tweet.text, tweet.created_at, "\n"
          # Send email
        end
      end
      sleep(rand(30..90)) # 30 - 90 second sleep
    end
  end
end
