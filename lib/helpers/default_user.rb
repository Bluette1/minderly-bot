require_relative '../user'
require_relative '../app_config'

class DefaultUser
  def self.retrieve
    config = AppConfig.new

    User.new({
               chat_id: config.default_chat_id,
               first_name: 'Marylene',

               last_name: 'Sawyer',
               sex: 'F',
               birthday: Date.parse('19/04/1980'),
               birthdays: { "Ben Sawyer": Date.parse('06/03/1994') },
               anniversaries: { "Ben and Marylene Sawyer": Date.parse('16/09/2011') }
             })
  end
end
