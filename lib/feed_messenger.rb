require 'rss'
require 'open-uri'
require_relative './message_sender'

class FeedMessenger
  attr_reader :config, :bot

  def initialize(options)
    @config = options[:config]
    @bot = options [:bot]
    @urls = [
      'https://www.history.com/.rss/full/this-day-in-history',
      'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml',
      'https://rss.nytimes.com/services/xml/rss/nyt/Science.xml',
      'https://rss.nytimes.com/services/xml/rss/nyt/Arts.xml',
      'https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml'
    ]
    send_feed
  end

  def send_feed(user = nil)
    if user.nil?
      Thread.new do
        loop do
          check_news
          interval = 3600
          sleep(interval)
        end
      end
    else
      check_news user
    end
  end

  private

  def check_news(user = nil)
    @urls.each do |url|
      news = {}
      URI.parse(url).open do |rss|
        feed = RSS::Parser.parse(rss)
        channel = pre_post_append feed.channel.title
        feed.items.each do |item|
          title = item.title
          news[title.to_sym] = item.link
        end
        if user.nil?
          send_to_users news, channel
        else
          send_to_users news, channel, user
        end
      end
    end
  end

  def pre_post_append(channel)
    channel = if channel.match?(/...History.../i)
                "===========Channel: #{channel}==========="
              else
                "----------------------------Channel: #{channel}---------------------------"
              end
    # p channel
    channel
  end

  def send_to_users(news, channel, user = nil)
    users = config.users
    choice = rand(5)
    news_item = choose_news_item choice, news, channel
    if user.nil?
      users.each do |user| # rubocop:todo Lint/ShadowingOuterLocalVariable
        feed user, news_item
      end
    else
      feed user, news_item
    end
  end

  def feed(user, news_item)
    send_rss news_item, user.chat_id
    send_rss news_item, config.group_id
    send_rss news_item, config.channel_id
  end

  def choose_news_item(choice, news, channel)
    news_item = {}
    index = 0
    news.each do |title, link|
      if choice == index
        news_item = {}
        news_item[:channel] = channel
        news_item[:title] = title
        news_item[:link] = link
        break
      end
      index += 1
    end
    news_item
  end

  def send_rss(news_item, chat_id)
    channel = news_item[:channel]
    title = news_item[:title]
    link = news_item[:link]

    MessageSender.new(
      bot: bot, chat: nil, text: "#{channel}\n#{title}\n#{link}"
    ).send_message chat_id
  end
end
