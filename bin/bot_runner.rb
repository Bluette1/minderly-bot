require 'telegram/bot'

require_relative '../lib/message_handler'
require_relative '../lib/app_config'

config = AppConfig.new

token = config.token

messagehandler = MessageHandler.new

puts 'Starting telegram bot: MinderlyBot'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    options = { bot: bot, message: message, config: config }

    messagehandler.update_params(options)

    puts "@#{message.from.username}: #{message.text}"

    messagehandler.handle
  end
end
