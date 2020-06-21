class User
  attr_reader :birthday, :important_days, :chat_id, :first_name, :sex

  def initialize(user_details)
    @first_name = user_details[:first_name]
    @last_name = user_details[:last_name]
    @sex = user_details[:sex]
    @birthday = user_details[:birthday]
    @important_days = {}
    @important_days[:birthdays] = user_details[:birthdays]
    @important_days[:anniversaries] = user_details[:anniversaries]
    @chat_id = user_details[:chat_id]
  end
end
