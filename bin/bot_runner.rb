require 'telegram/bot'

require_relative '../lib/message_handler'
require_relative '../lib/app_config'

config = AppConfig.new

token = config.token

puts 'Starting telegram bot: MinderlyBot'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    options = {bot: bot, message: message, config: config}

    puts "@#{message.from.username}: #{message.text}" 
    MessageHandler.new(options).handle
  end
end