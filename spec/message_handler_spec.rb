require_relative '../lib/message_handler'
require_relative '../lib/app_config'
require_relative '../lib/important_day_checker'
require_relative '../lib/feed_messenger'

describe MessageHandler do
  let(:bot) { {} }
  let(:message) { { text: '/command' } }
  let(:config) { AppConfig.new }
  let(:handler) { MessageHandler.new }
  let(:day_checker) { ImportantDayChecker.new(config: config, bot: bot) }
  let(:feeder) { FeedMessenger.new(config: config, bot: bot) }

  describe '#initialise' do
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
    let(:options) do
      {
        bot: bot,
        message: message,
        config: config,
        day_checker: day_checker,
        feeder: feeder
      }
    end

    it 'returns the correct instance variables' do
      handler.update_params(options)
      expect(handler.bot).to eq({})
      expect(handler.message).to eq(message)
      expect(handler.instance_variable_get(:@config)).to eq(config)
      expect(handler.instance_variable_get(:@commands)).to eq(config.commands)
      expect(handler.instance_variable_get(:@day_checker)).to eq(day_checker)
      expect(handler.instance_variable_get(:@feeder)).to eq(feeder)
    end
  end
end
