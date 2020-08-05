require_relative './message_sender'

class ImportantDayChecker
  attr_reader :config, :bot

  def initialize(options)
    @config = options[:config]
    @bot = options [:bot]
    check_today
  end

  def check_today(user = nil)
    if user.nil?
      Thread.new do
        loop do
          check_important_days
          interval = 24 * 3600
          sleep(interval)
        end
      end
    else
      check_important_days user
    end
  end

  private

  def check_important_days(user = nil)
    if user.nil?
      users = config.users
      users.each do |user| # rubocop:todo Lint/ShadowingOuterLocalVariable
        check_important_days_for_user user

        check_default_important_days user
      end

    else
      check_default_important_days user

      check_important_days_for_user user

    end
  end

  def check_default_important_days(user = nil) # rubocop:todo Metrics/CyclomaticComplexity
    days = config.default_important_days
    days.each do |_day, details|
      next unless (today.month == details[0].month) && (today.day == details[0].day)

      text_user = (details[1] + ', ' + user.first_name + '!').center(55, '*')
      send_message user.chat_id, text_user unless user.nil? || user.sex != details[2]

      text_group = (details[1] + '!').center(55, '*')
      send_message config.group_id, text_group unless config.group_id.nil?
      send_message config.channel_id, text_group unless config.channel_id.nil?
    end
  end

  def check_important_days_for_user(user)
    check_user_birthday user
    birthdays = user.important_days[:birthdays]
    check_days birthdays, 'birthday', user
    anniversaries = user.important_days[:anniversaries]
    check_days anniversaries, 'anniversary', user
  end

  def check_user_birthday(user)
    chat_id = user.chat_id
    if user.birthday.month == today.month and user.birthday.day == today.day # rubocop:todo Style/GuardClause
      text = "Happy birthday, #{user.first_name}!".center(60, '*')
      send_message chat_id, text
    end
  end

  def check_days(important_days, day, user)
    chat_id = user.chat_id
    important_days.each do |name, date|
      next unless (today.month == date.month) && (today.day == date.day)

      text = "Happy #{day}, #{name}!".center(60, '*')
      send_message chat_id, text
      send_message config.group_id, text unless config.group_id.nil?
      send_message config.channel_id, text unless config.channel_id.nil?
    end
  end

  def today
    Date.today
  end

  def send_message(chat_id, text)
    MessageSender.new(
      bot: bot, chat: nil, text: text
    ).send_message chat_id
  end
end
