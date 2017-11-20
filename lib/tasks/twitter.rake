require 'pony'
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
mail_text = ''

namespace :twitter do
  task :scan => :environment do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch("TWITTER_CONSUMER_KEY")
      config.consumer_secret     = ENV.fetch("TWITTER_CONSUMER_SECRET")
      config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
      config.access_token_secret = ENV.fetch("TWITTER_ACCESS_SECRET")
    end

    TICKERS.each do |ticker|
      ticker_text = "Scanning #{ticker} on Twitter...\n"
      puts ticker_text
      mail_text << ticker_text
      client.search("#{ticker}", result_type: "recent").take(50).collect do |tweet|
        if keywords.any? { |keyword| tweet.text.downcase.include? keyword }
          text = "https://twitter.com/statuses/#{tweet.id}\n#{tweet.text}\n#{tweet.created_at}\n\n"
          puts text
          mail_text << text
        end
      end
      sleep(rand(3..5)) # 30 - 90 second sleep
    end

    Pony.mail({
      from: 'alerts@coinfi.com',
      to: 'admin@coinfi.com',
      subject: 'Twitter Alert',
      body: mail_text,
      charset: 'utf-8',
      via: :smtp,
      via_options: {
        address: 'smtp.webfaction.com',
        port: 587,
        enable_starttls_auto: true,
        user_name: 'coinfi',
        password: ENV.fetch('WEBFACTION_SMTP_PASSWORD'),
        authentication: :plain,
        domain: 'coinfi.com',
      }
    })
  end
end
