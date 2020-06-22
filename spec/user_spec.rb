require_relative '../lib/user'

describe User do
  describe '#initialise' do
    let(:birthdays) { { Hannah: '12/03/2000' } }
    let(:anniversaries) { { Smiths: '12/03/2009' } }
    let(:user_details) do
      {
        first_name: 'Mary',
        last_name: 'Sewyr',
        username: 'MaryleneSawyer',
        chat_id: 'id',
        birthday: '23/12/1999',
        birthdays: birthdays,
        anniversaries: anniversaries
      }
    end
    let(:user) { User.new(user_details) }

    it 'returns the correct instance variables' do
      expect(user.first_name).to eq 'Mary'
      expect(user.instance_variable_get(:@last_name)).to eq 'Sewyr'
      expect(user.instance_variable_get(:@username)).to eq 'MaryleneSawyer'
      expect(user.birthday).to eq '23/12/1999'
      expect(user.chat_id).to eq 'id'
      expect(user.important_days[:birthdays]).to eq birthdays
      expect(user.important_days[:anniversaries]).to eq anniversaries
    end
  end
end
