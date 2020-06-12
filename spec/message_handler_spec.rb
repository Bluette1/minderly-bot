require_relative '../lib/message_handler'
require_relative '../lib/app_config'

describe MessageHandler do
  let(:bot) { {} }
  let(:message) { { text: '/command' } }
  let(:config) { AppConfig.new }
  let(:handler) { MessageHandler.new }

  describe '#initialise' do
    let(:options) { { bot: bot, message: message, config: config } }

    it 'returns the correct instance variables' do
      expect(handler.instance_variable_get(:@birthdays)).to eq({})
      expect(handler.instance_variable_get(:@anniversaries)).to eq({})
      expect(handler.instance_variable_get(:@user_details)).to eq({})
      expect(handler.instance_variable_get(:@proceed)).to eq false
      expect(handler.instance_variable_get(:@ongoing_subscribe)).to eq false
      expect(handler.instance_variable_get(:@ongoing_update)).to eq false
      expect(handler.instance_variable_get(:@done)).to eq false
      expect(handler.instance_variable_get(:@name_set)).to eq false
      expect(handler.instance_variable_get(:@name)).to eq ''
      expect(handler.instance_variable_get(:@steps)).to eq(0)
    end
  end

  describe '#update_params' do
    let(:options) { { bot: bot, message: message, config: config } }

    it 'returns the correct instance variables' do
      handler.update_params(options)
      expect(handler.bot).to eq({})
      expect(handler.message).to eq(message)
      expect(handler.user_details).to eq({})
    end
  end
end
