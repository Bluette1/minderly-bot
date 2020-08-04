require 'dotenv/load'
class AppConfig
  attr_reader :users, :token, :commands, :channel_id, :group_id, :default_important_days

  def initialize
    @users = []
    @token = retrieve_token
    @commands = retrieve_commands
    @channel_id = retrieve_channel_id
    @group_id = retrieve_group_id
    @default_important_days = retrieve_default_important_days
  end

  def add_user?(user)
    res = true
    @users.each do |existing_user|
      if existing_user.chat_id == user.chat_id
        res = false
        break
      end
    end
    @users << user if res
    res
  end

  def update_user?(user)
    res = false
    @users.each do |existing_user|
      next unless existing_user.chat_id == user.chat_id

      @users.delete(existing_user)
      @users << user
      res = true
      break
    end
    res
  end

  private

  def retrieve_token
    ENV['token']
  end

  def retrieve_commands
    commands = [
      '/start',
      '/help',
      '/stop',
      '/add_my_birthday',
      '/add_birthday',
      '/add_anniversary',
      '/subscribe',
      '/update'
    ]
    commands
  end

  def retrieve_group_id
    ENV['group_id']
  end

  def retrieve_channel_id
    ENV['channel_id']
  end

  def retrieve_default_important_days
    today = Date.today
    {
      Christmas: [Date.parse("25/12/#{today.year}"), 'Wishing you a Merry Christmas', 'B'],
      Fathers_Day: [Date.parse("21/06/#{today.year}"), 'Happy Father\'s day', 'M'],
      Mothers_Day: [Date.parse("10/05/#{today.year}"), 'Happy Mother\'s day', 'F']
    }
  end
end
