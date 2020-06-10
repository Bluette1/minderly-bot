require 'rss'
require 'open-uri'
require_relative './message_sender'



class FeedMessenger

attr_reader :config, :bot

def initialize(options)
  @config = options[:config]
  @bot = options [:bot]
  @url = 'http://rss.cnn.com/rss/edition.rss'
end

def send_feed
  Thread.new do
    loop do
      check_news
      interval = 3600
      sleep(interval)
    end
  end
end

private

def check_news 
 news = {}
 open(@url) do |rss|
  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  feed.items.each do |item|
  title = item.title
  news[title.to_sym] = item.link
  end
  send_to_users news
end
end


def send_to_users news
  users = config.users
  choice = rand(5)
  news_item = choose_news_item choice, news
  users.each do |user|
    send_rss news_item, user.chat_id
    send_rss news_item, config.group_id
    send_rss news_item, config.channel_id
  end
end

def choose_news_item choice, news
  index = 0
   news.each do |title, link|
    if choice == index
      news_item = {}
      news_item[:title] = title
      news_item[:link] = link
      return news_item
    end
    index += 1
   
   end
end
def send_rss news_item, chat_id
  
  title = news_item[:title]

  link = news_item[:link]

  MessageSender.new(
    bot: bot, chat: nil, text: title
  ).send_message chat_id

  MessageSender.new(
    bot: bot, chat: nil, text: link
  ).send_message chat_id
  # MessageSender.new(
  #   bot: bot, chat: nil, text: text
  # ).send_message config.group_id
  # MessageSender.new(
  #   bot: bot, chat: nil, text: text
  # ).send_message config.channel_id
 
end

# Crono.perform(YourJob).every 1.day, at: {hour: 8, min: 00}
# https://github.com/plashchynski/crono
# https://stackoverflow.com/questions/59166469/how-to-schedule-a-telegram-bot-to-send-a-message
end