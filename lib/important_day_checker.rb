require_relative './message_sender'

class ImportantDayChecker
  attr_reader :config, :bot

  def initialize(options)
    @config = options[:config]
    @bot = options [:bot]
  end

  def check_important_days
    users = config.users
    users.each do |user|
      birthdays = user.important_days[:birthdays]
      check_days birthdays, 'birthday', user.chat_id
      anniversaries = user.important_days[:anniversaries]
      check_days anniversaries, 'anniversary', user.chat_id
    end
  end

  def check_days(important_days, day, chat_id)
    important_days.each do |name, date|
      today = Date.today
      next unless (today.month == date.month) && (today.day == date.day)

      text = "Happy #{day} @#{name}!"
      MessageSender.new(
        bot: bot, chat: nil, text: text
      ).send_wishes_message chat_id
      MessageSender.new(
        bot: bot, chat: nil, text: text
      ).send_wishes_message config.group_id
      MessageSender.new(
        bot: bot, chat: nil, text: text
      ).send_wishes_message config.channel_id
    end
  end

  def check_today
    Thread.new do
      loop do
        check_important_days
        interval = 24 * 3600
        sleep(interval)
      end
    end
  end
end
