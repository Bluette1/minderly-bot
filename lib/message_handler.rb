require_relative './message_sender'
require_relative './user'

class MessageHandler
  attr_reader :message, :bot, :user_details

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @config = options[:config]
    @commands = @config.commands
    @importtant_days = {}
    @birthdays = {}
    @anniversaries = {}
    @user_details = {}
  end

  def handle
    command = message.text.split(" ")[0]
    send_default unless @commands.include?(command)
    case message.text.split(" ")[0]
    when '/start'
        send_greeting_message
    when '/stop'
        send_farewell_message
    when '/help'
        send_help_message  
    when '/subscribe'
      send_subscribe_message
    when '/birthday'
      add_birthday
    when '/my_birthday'
      add_my_birthday
    when '/anniversary'
      add_anniversaries
    end
  end

  private

  def send_greeting_message
    greetings = ['bonjour', 'hola', 'hallo', 'sveiki', 'namaste', 'shalom', 'salaam', 'szia', 'halo', 'ciao']
    MessageSender.new(bot: bot, chat: message.chat, text: "#{greetings.sample.capitalize}, #{message.from.first_name}").send
  end

  def send_farewell_message
    MessageSender.new(bot: bot, chat: message.chat, text: "Bye, #{message.from.first_name}").send
  end

  def send_help_message
    MessageSender.new(
      bot: bot,
      chat: message.chat,
      text: "Please enter any of the following commands: #{@commands.to_s}"
    ).send     
  end

  def send_subscribe_message
    @user_details = {chat_id: message.chat.id}
    important_days = {}
    @user_details[:important_days] = important_days
    
    MessageSender.new(
      bot: bot,
      chat: message.chat,
      text: "Registration in process: please enter /my_birthday followed by your birthday in the format: DD/MM/YYYY"
    ).send 

  end

  def add_my_birthday
    @user_details[:birthday] = message.text.split(" ")[1]
    MessageSender.new(
      bot: bot,
      chat: message.chat,
      text: "Enter your family/friend's birthday."\
      "Please enter /birthday followed by your family/friends' birthdays in the format: 'friend: DD/MM/YYYY'."\
      "Enter /stop to quit or /help for more options"
    ).send 
  end

  def add_birthday
    birthday = message.text.split(" ")[1]
    friend = {}
    friend[birthday.split(": ")[0]] = birthday.split(": ")[1]
    @birthdays.merge(friend)
  end

  def add_anniversaries

    anniversary = message.text.split(" ")[1]
    friend = {}
    
    friend[anniversary.split(": ")[0]] = anniversary.split(": ")[1]
      @anniversaries.merge(friend) 
  end

  def send_default
    MessageSender.new(bot: bot, chat: message.chat, text: "Unknown command.Please enter any of the following commands: #{@commands.to_s}").send 
  end
end