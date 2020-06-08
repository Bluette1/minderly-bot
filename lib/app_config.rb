class AppConfig
  
  attr_reader :users, :token, :commands

  def initialize()
    @users = [] 
    @token = get_token
    @commands = get_commands
  end


  def add_user(user)
    @users << user
  end

  private

  def get_token
    token = '1223539527:AAGBZYp4D7QL7P7xJtUm7EINhOymX9MezwE'
    token
  end

  def get_commands
    commands = ['/start', '/help', '/stop', '/subscribe', '/my_birthday', '/birthday']
    commands
  end
end