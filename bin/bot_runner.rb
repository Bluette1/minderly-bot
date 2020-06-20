require 'telegram/bot'

require_relative '../lib/message_handler'
require_relative '../lib/app_config'
require_relative '../lib/important_day_checker'
require_relative '../lib/feed_messenger'

config = AppConfig.new

token = config.token

puts 'Starting telegram bot: MinderlyBot'

Telegram::Bot::Client.run(token) do |bot|
  messagehandler = MessageHandler.new
  day_checker = ImportantDayChecker.new(config: config, bot: bot)
  feeder = FeedMessenger.new(config: config, bot: bot)

  bot.listen do |message|
    options = {
      bot: bot,
      message: message,
      config: config,
      day_checker: day_checker,
      feeder: feeder
    }

    messagehandler.update_params(options)

    puts "@#{message.from.username}: #{message.text}"

    messagehandler.handle
  end
end
