require_relative './app_config'

class MessageSender
  attr_reader :bot, :text

  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
  end

  def send
    puts "sending '#{text}' to @#{@chat.username}"
    bot.api.send_message(chat_id: @chat.id, text: text)
  end

  def send_message(chat_id)
    bot.api.send_message(chat_id: chat_id, text: text)
  end
end
