require_relative './message_sender'
require_relative './user'
require_relative './important_day_checker'
require_relative './feed_messenger'
class MessageHandler # rubocop:todo Metrics/ClassLength
  attr_reader :message, :bot, :user_details

  def initialize
    @birthdays = {}
    @anniversaries = {}
    @user_details = {}
    @proceed = false
    @previous_command = ''
    @ongoing_subscribe = false
  end

  def update_params(options)
    @bot = options[:bot]
    @message = options[:message]
    @config = options[:config]
    @commands = @config.commands
  end

  def handle # rubocop:todo Metrics/CyclomaticComplexity
    command = retrieve_command
    case command
    when '/start'
      greet_user
    when '/stop'
      send_message "Bye, #{message.from.first_name}"
    when '/help'
      send_message "Please enter any of the following commands: #{@commands}"
    when '/subscribe'
      handle_subscribe command
    when '/update'
      handle_update
    when '/add_birthday'
      prompt_user command
    when '/add_my_birthday'
      prompt_user command
    when '/add_anniversary'
      prompt_user command
    end
  end

  private

  def retrieve_command
    command = if @proceed
                @previous_command
              else
                message.text
              end
    unless @commands.include?(command) || @proceed
      err_message = "Unknown command #{command}. Please enter any " \
      "of the following commands: #{@commands}"
      send_message err_message
    end
    command
  end

  def greet_user
    greetings = %w[
      bonjour hola hallo sveiki namaste shalom salaam szia halo ciao
    ]
    send_message "#{greetings.sample.capitalize}, #{message.from.first_name}!\n Enter /help for options."
  end

  def send_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def handle_subscribe(command) # rubocop:todo Metrics/MethodLength
    @ongoing_subscribe = true
    if @user_details[:chat_id].nil?
      @user_details = { chat_id: message.chat.id }
      @proceed = true
      @previous_command = command
    end
    if @user_details[:birthday].nil?
      @proceed = false
      prompt_user '/add_my_birthday'
    elsif user_details[:birthdays].nil?
      send_message 'Please add at least one birthday to be reminded of'
      prompt_user '/add_birthday'
    elsif user_details[:anniversaries].nil?
      send_message 'Please add at least one anniversary to be reminded of'
      prompt_user '/add_anniversary'
    else
      @proceed = false
      @previous_command = ''
      @ongoing_subscribe = false
      subscribe_user
    end
  end

  def subscribe_user
    user = User.new(@user_details)
    if @config.add_user?(user)
      send_message 'Your subscription was successful.'
      ImportantDayChecker.new(config: @config, bot: bot).check_today
      FeedMessenger.new(config: @config, bot: bot).send_feed

    else
      send_message "You are already subscribed, please enter '/update'"\
       'to update your subscription'
    end
  end

  def add_my_birthday
    @user_details[:chat_id] = message.chat.id
    valid = true
    begin
      @user_details[:birthday] = Date.parse(message.text.strip)
    rescue StandardError => e
      send_message "#{e}: Incorrect format for birthday date entry."
      valid = false
    end

    if valid
      send_message 'Your birthday has been successfully added.'
      message.text = nil
      next_action
    else
      prompt_user '/add_my_birthday'
    end
  end

  def add_birthday
    if message.text.nil?
      prompt_user '/add_birthday'
    else
      birthday_entry = message.text.split(':')
      valid = true
      begin
        @birthdays[birthday_entry[0].strip.capitalize] = Date.parse(birthday_entry[1].strip)
      rescue StandardError => e
        valid = false
        send_message "#{e}: Incorrect format for birthday date entry."
      end
      if valid
        @user_details[:birthdays] = @birthdays
        send_message 'The birthday has been successfully added.'

        message.text = nil
        next_action
      else
        prompt_user '/add_birthday'
      end
    end
    # rubocop:todo Style/CommentedKeyword
  end # rubocop:enable Metrics/MethodLength  # rubocop:enable Style/CommentedKeyword
  # rubocop:enable Style/CommentedKeyword

  def add_anniversary # rubocop:todo Metrics/MethodLength
    if message.text.nil?
      prompt_user '/add_anniversary'
    else
      anniversary_entry = message.text.split(':')
      valid = true
      begin
        anniversary_date = Date.parse(anniversary_entry[1].strip)
        @anniversaries[anniversary_entry[0].strip.capitalize] = anniversary_date
      rescue StandardError => e
        valid = false
        send_message "#{e}: Incorrect format for anniversary date entry."
      end
      if valid
        @user_details[:anniversaries] = @anniversaries
        send_message 'The anniversary has been successfully added.'
        message.text = nil
        next_action
      else
        prompt_user '/add_anniversary'
      end
    end
    # rubocop:todo Style/CommentedKeyword
  end # rubocop:enable Metrics/MethodLength  # rubocop:enable Style/CommentedKeyword

  # rubocop:enable Style/CommentedKeyword

  def handle_update
    send_message 'Please enter either of the commands:' \
     " '/add_my_birthday', '/add_birthday', or '/add_anniversary'"\
      " to update your birthday, and add birthdays and anniversaries to be"\
      " reminded of respectively."
  end

  def update_user
    new_user = User.new(user_details)
    if @config.update_user?(new_user)
      send_message 'Your subscription has been successfully updated'
      ImportantDayChecker.new(config: @config, bot: bot).check_today
      FeedMessenger.new(config: @config, bot: bot).send_feed
    else
      send_message "The user subscription doesn't exist. Please press"\
       '/subscribe to subscribe'
    end
  end

  def prompt_user(command)
    if @proceed
      @proceed = false
      @previous_command = ''
      chose_action command
    else
      @proceed = true
      @previous_command = command
      send_message choose_message(command)
    end
  end

  def prompt_subscribe
    @proceed = true
    @previous_command = '/subscribe'
    handle
  end

  def chose_action(command)
    case command
    when '/add_birthday'
      add_birthday
    when '/add_my_birthday'
      add_my_birthday
    when '/add_anniversary'
      add_anniversary
    end
  end

  def choose_message(command)
    case command
    when '/add_birthday'
      "Please enter a birthday in the format: 'name: DD/MM/YYYY'."
    when '/add_my_birthday'
      "Enter your birthday in the format 'DD/MM/YYYY'"
    when '/add_anniversary'
      "Please enter an anniversary in the format: 'couple name: DD/MM/YYYY'."
    end
  end

  def next_action
    if @ongoing_subscribe
      prompt_subscribe
    else
      update_user
    end
  end
end
