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
    @steps = 0
    @previous_command = ''
    @ongoing_subscribe = false
    @ongoing_update = false
    @name = ''
    @done = false
    @name_set = false
    @sex = ''
  end

  def update_params(options)
    @bot = options[:bot]
    @message = options[:message]
    @config = options[:config]
    @commands = @config.commands
    @day_checker = options[:day_checker]
    @feeder = options[:feeder]
  end

  def handle
    command = retrieve_command
    handle_commands command
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

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  def handle_commands(command) # rubocop:todo Metrics/CyclomaticComplexity
    case command
    when '/start'
      greet_user
    when '/stop'
      send_message "Bye, #{message.from.first_name}"
    when '/help'
      send_message "Please enter any of the following commands: #{@commands}"
    when '/news'
      handle_news
    when '/subscribe'
      handle_subscribe command
    when '/update'
      handle_update
    when '/add_birthday'
      @name = message.text if @name_set and @name.empty?
      prompt_user command
    when '/add_my_birthday'
      prompt_user command
    when '/add_anniversary'
      @name = message.text if @name_set and @name.empty?
      prompt_user command

    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  def greet_user
    greetings = %w[
      bonjour hola hallo sveiki namaste shalom salaam szia halo ciao
    ]
    send_message "#{greetings.sample.capitalize}, #{message.from.first_name}!\n Enter /help for options."
  end

  def send_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def handle_update # rubocop:todo Metrics/CyclomaticComplexity
    @ongoing_update = true
    if @steps.zero?
      @proceed = true
      @previous_command = '/update'
      @steps += 1
      send_message 'Please  enter y[es] or n[o] if would like to update your birthday'
    elsif @steps == 1

      case message.text[0].downcase
      when 'y'
        @steps += 1
        message.text = nil
        @proceed = false
        prompt_user '/add_my_birthday', false, false, true, '/update', true

      when 'n'
        @steps += 1
        handle
      else
        @steps = 0
        handle
      end
    elsif @steps == 2
      add_sex
      @steps += 1
    elsif @steps == 3
      @steps += 1
      send_message 'Please  enter y[es] or n[o] if you would like to update or add a birthday'

    elsif @steps == 4

      case message.text[0].downcase
      when 'y'
        @steps += 1
        message.text = nil
        @proceed = false
        prompt_user '/add_birthday', true, false, false, '/update', true
        unless message.text.nil?
          @proceed = false
          @name = message.text
          prompt_user '/add_birthday', false, true, true, '/update', true
        end
      when 'n'
        @steps += 1
        handle
      else
        @steps = 3
        handle
      end
    elsif @steps == 5
      @steps += 1
      send_message 'Please  enter y[es] or n[o] if would like to update or add an anniversary'
    elsif @steps == 6
      case message.text[0].downcase
      when 'y'
        @steps += 1
        message.text = nil
        @proceed = false
        prompt_user '/add_anniversary', true, false, false, '/update', true
        unless message.text.nil?
          @name = message.text
          @proceed = false
          @name = message.text
          prompt_user '/add_anniversary', false, true, true, '/update', true
        end
      when 'n'
        @steps += 1
        handle
      else
        @steps = 5
        handle
      end
    else
      @steps = 0
      @proceed = false
      @previous_command = ''
      @name = ''
      @name_set = false
      @sex = ''
      @ongoing_update = false
      update_user
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  def handle_subscribe(command) # rubocop:todo Metrics/CyclomaticComplexity
    @ongoing_subscribe = true
    if @user_details[:chat_id].nil?
      @user_details = { chat_id: message.chat.id }
      @proceed = true
      @previous_command = command
    end
    if @user_details[:birthday].nil?
      @proceed = false
      prompt_user '/add_my_birthday', false, false, true
    elsif @sex.empty?
      add_sex
    elsif user_details[:birthdays].nil?
      send_message 'Please add at least one birthday to be reminded of'
      @proceed = false
      prompt_user '/add_birthday', true, false, false

      unless message.text.nil?
        @name = message.text
        @proceed = false
        prompt_user '/add_birthday', false, true, true
      end

    elsif user_details[:anniversaries].nil?
      send_message 'Please add at least one anniversary to be reminded of'

      prompt_user '/add_anniversary', true, false, false

      unless message.text.nil?
        @done = true
        @proceed = false
        @name = message.text
        @proceed = false
        prompt_user '/add_anniversary', false, true, true
      end

    else
      @proceed = false
      @previous_command = ''
      @name = ''
      @name_set = false
      @sex = ''
      @ongoing_subscribe = false
      subscribe_user
    end
  end

  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
  def handle_news
    @feeder.send_feed(message.chat.id)
  end

  def subscribe_user
    user = User.new(@user_details)
    if @config.add_user?(user)
      send_message 'Your subscription was successful.'
      @day_checker.check_today(user)
      # @feeder = FeedMessenger.new(config: config, bot: bot)
      @feeder.send_feed(user.chat_id)

    else
      send_message "You are already subscribed, please enter '/update'"\
       'to update your subscription'
    end
  end

  def add_my_birthday # rubocop:todo Metrics/MethodLength
    if message.text.nil?
      prompt_user '/add_my_birthday', true, false, false
    else

      @user_details[:chat_id] = message.chat.id
      @user_details[:sex] = @sex
      valid = true
      @user_details[:first_name] = message.from.first_name
      @user_details[:last_name] = message.from.last_name
      @user_details[:username] = message.from.username
      begin
        @user_details[:birthday] = Date.parse(message.text.strip)
      rescue StandardError => e
        send_message "#{e}: Incorrect format for birthday date entry."
        valid = false
      end

      if valid
        send_message 'Your birthday has been successfully added.'
        @name = ''
        @name_set = false
        message.text = nil
        next_action
      else
        prompt_user '/add_my_birthday', true, false, false
      end
    end
  end

  def add_birthday # rubocop:todo Metrics/MethodLength
    if message.text.nil?
      prompt_user '/add_birthday', true, false, false
    else
      names = @name.strip.split(' ')
      names.map!(&:capitalize)
      valid = true
      begin
        @birthdays[names.join(' ')] = Date.parse(message.text.strip)
      rescue StandardError => e
        valid = false
        send_message "#{e}: Incorrect format for birthday date entry."
      end
      if valid
        @user_details[:birthdays] = @birthdays
        send_message 'The birthday has been successfully added.'
        @name = ''
        @name_set = false
        message.text = nil
        next_action
      else
        prompt_user '/add_birthday', true, false, false
      end
    end
  end

  # rubocop:todo Metrics/PerceivedComplexity
  def add_anniversary # rubocop:todo Metrics/MethodLength
    if message.text.nil?
      prompt_user '/add_anniversary', true, false, false
    else
      valid = true
      names = @name.strip.split(' ')
      names.map! do |name|
        if name.downcase == 'and'
          name
        else
          name.capitalize
        end
      end
      begin
        anniversary_date = Date.parse(message.text.strip)
        @anniversaries[names.join(' ')] = anniversary_date
      rescue StandardError => e
        valid = false
        send_message "#{e}: Incorrect format for anniversary date entry."
      end
      if valid
        @user_details[:anniversaries] = @anniversaries
        send_message 'The anniversary has been successfully added.'
        @name_set = false
        @name = ''
        message.text = nil
        next_action
      else
        prompt_user '/add_anniversary', true, false, false
      end
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def update_user
    new_user = User.new(user_details)
    if @config.update_user?(new_user)
      send_message 'Your subscription has been successfully updated' << "\n" \
                   'You can use either of the commands:' \
                  " '/add_my_birthday', '/add_birthday', or '/add_anniversary'"\
                   ' to update your birthday, and add birthdays and anniversaries to be'\
                   ' reminded of respectively.'
      @day_checker.check_today(new_user)
      # @feeder = FeedMessenger.new(config: config, bot: bot)
      @feeder.send_feed(new_user.chat_id)
    else
      send_message "The user subscription doesn't exist. Please enter "\
       '/subscribe to subscribe'
    end
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/ParameterLists
  def prompt_user(command, _name = false, _date = false, _done = false, previous_command = '', proceed = false)
    # rubocop:enable Metrics/ParameterLists
    if @done
      unless message.text.nil?
        @done = false
        @proceed = proceed
        @previous_command = previous_command
        chose_action command
      end
    else
      if !@name.empty? # rubocop:todo Style/IfInsideElse
        @done = true
        @proceed = true
        @previous_command = command
        message.text = nil
        send_message choose_message command, false, true
      else
        if command == '/add_my_birtday'
          @done = true
        else
          @name_set = true
          @done = false
        end
        @proceed = true
        @previous_command = command
        message.text = nil
        send_message choose_message command, true, false
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  def prompt_subscribe
    @proceed = true
    @previous_command = '/subscribe'
    handle
  end

  def prompt_update
    @proceed = true
    @previous_command = '/update'
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

  # rubocop:todo Metrics/PerceivedComplexity
  def choose_message(command, name, date) # rubocop:todo Metrics/CyclomaticComplexity
    case command
    when '/add_birthday'
      if name
        'Please enter the name of the person whose birthday you would like to save'
      elsif date
        "Please enter the birthday date in the format 'DD/MM/YYYY'"
      end
    when '/add_my_birthday'
      @done = true
      "Enter your birthday in the format 'DD/MM/YYYY'"
    when '/add_anniversary'
      if name
        'Please enter the name of the couple whose anniversary you would like to save, for example, John and Mary'
      elsif date
        "Please enter the anniversary date in the format 'DD/MM/YYYY'"
      end
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def next_action
    if @ongoing_subscribe
      prompt_subscribe
    elsif @ongoing_update
      prompt_update
    else
      update_user
    end
  end

  def add_sex
    if message.text.nil?
      send_message 'Please enter [m]ale or [f]emale for male or female respectively'
    else
      while @sex.empty?

        case message.text[0].downcase
        when 'm'
          @sex = 'M'
        when 'f'
          @sex = 'F'
        else
          send_message 'Please enter [m]ale or [f]emale for male or female respectively'
        end
      end
      message.text = nil
      next_action
    end
  end
end
