require_relative '../user'

class DefaultUser
  def self.retrieve
    User.new({
               chat_id: 1_168_103_238,
               first_name: 'Marylene',
               last_name: 'Sawyer',
               sex: 'female',
               birthday: Date.parse('13/03/1989'),
               birthdays: { "Ben Sawyer": Date.parse('12/10/1984') },
               anniversaries: { "Ben and Marylene Sawyer": Date.parse('06/05/2011') }
             })
  end
end
