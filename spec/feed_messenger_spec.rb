require_relative '../lib/feed_messenger'

describe FeedMessenger do
  let(:bot) { {} }
  let(:config) { {} }

  describe '#initialise' do
    let(:options) { { bot: bot, config: config } }
    let(:feeder) { FeedMessenger.new(options) }

    it 'returns the correct instance variables' do
      allow(Thread).to receive(:new) do
      end

      expect(feeder.bot).to eq(bot)
      expect(feeder.config).to eq(config)
    end
  end
end
