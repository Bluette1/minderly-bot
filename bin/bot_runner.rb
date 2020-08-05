require 'telegram/bot'

require_relative '../lib/message_handler'
require_relative '../lib/app_config'
require_relative '../lib/important_day_checker'
require_relative '../lib/feed_messenger'
require_relative '../lib/helpers/default_user'

config = AppConfig.new
begin
  config.add_user?(DefaultUser.retrieve)
  puts 'Default user successfully added'
rescue StandardError => e
  puts 'Failed to add default user'
end
# if config.add_user?(DefaultUser.retrieve)
#   puts 'Default user successfully added'
# else
#   puts 'Failed to add default user'
# end

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
    user_name = message.from.nil? ? '' : message.from.username
    puts "@#{user_name}: #{message.text}"

    messagehandler.handle
  end
end
