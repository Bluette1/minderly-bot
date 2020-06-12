class User
  attr_reader :birthday, :important_days, :chat_id

  def initialize(user_details)
    @birthday = user_details[:birthday]
    @important_days = {}
    @important_days[:birthdays] = user_details[:birthdays]
    @important_days[:anniversaries] = user_details[:anniversaries]
    @chat_id = user_details[:chat_id]
  end
end
