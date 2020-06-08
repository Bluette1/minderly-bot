class User
  attr_reader :birthday, :important_days, :chat_id

  def initialize(user_details)
      @birthday = user_details[:birthday]
      @important_days= user_details[:important_days]
      @chat_id = user_details[:chat_id]
  end 
end