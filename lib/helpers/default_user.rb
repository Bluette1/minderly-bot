require_relative '../user'

class DefaultUser
  def self.retrieve
    User.new({
               chat_id: 1_168_103_238,
               first_name: 'Marylene',

               last_name: 'Sawyer',
               sex: 'F',
               birthday: Date.parse('19/04/1980'),
               birthdays: { "Ben Sawyer": Date.parse('06/03/1994') },
               anniversaries: { "Ben and Marylene Sawyer": Date.parse('16/09/2011') }
             })
  end
end
