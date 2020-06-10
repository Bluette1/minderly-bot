require_relative '../lib/app_config'
require_relative '../lib/user'

describe AppConfig do
  let(:config) { AppConfig.new }

  describe '#initialise' do
    it 'returns the correct instance variables' do
      expect(config.users).to eq []
      expect(config.instance_variable_get(:@token)).to eq '1275428552:AAF5BvjOOhCanGGNg6Qk5pPfVW0yjlmKi7s'
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
      expect(config.commands).to eq(commands)
      expect(config.group_id).to eq('-485549964')
      expect(config.channel_id).to eq('-1001482906311')
    end
  end

  describe '#add_user' do
    let(:user_details) { { chat_id: 'id' } }
    let(:user) { User.new(user_details) }
    it 'When user does not exist' do
      expect(config.add_user(user)). to eq(true)
      expect(config.users). to eq([user])
    end

    it 'When user already exists' do
      config.instance_variable_set(:@users, [user])
      expect(config.add_user(user)). to eq(false)
      expect(config.users). to eq([user])
    end
  end

  describe '#update_user' do
    let(:user_details) { { chat_id: 'another-id' } }
    let(:user) { User.new(user_details) }
    it 'When user already exists' do
      config.instance_variable_set(:@users, [user])
      expect(config.update_user(user)). to eq(true)
      expect(config.users). to eq([user])
    end

    it 'When user doesn\'t exist' do
      expect(config.update_user(user)). to eq(false)
      expect(config.users). to eq([])
    end
  end
end
