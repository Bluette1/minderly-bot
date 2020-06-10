require_relative '../lib/user'

describe User do

    describe '#initialise' do
        let(:birthdays) {{Hannah: '12/03/2000'}}
        let(:anniversaries) {{Smiths: '12/03/2009'}}
        let(:user_details) {{chat_id: 'id', birthday: '23/12/1999', birthdays: birthdays, anniversaries: anniversaries}}
        let(:user) { User.new(user_details)}

        it 'returns the correct instance variables' do 
            expect(user.birthday).to eq ('23/12/1999')
            expect(user.chat_id).to eq ('id')
            expect(user.important_days[:birthdays]).to eq (birthdays)
            expect(user.important_days[:anniversaries]).to eq (anniversaries) 
        end
    end   
end