require_relative '../lib/feed_messenger'
require_relative '../lib/app_config'

describe FeedMessenger do
  let(:bot) { {} }
  let(:config) { {} }
  let(:urls) do
    ['https://www.history.com/.rss/full/this-day-in-history',
     'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml',
     'https://rss.nytimes.com/services/xml/rss/nyt/Science.xml',
     'https://rss.nytimes.com/services/xml/rss/nyt/Arts.xml',
     'https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml']
  end

  describe '#initialise' do
    let(:options) { { bot: bot, config: config } }
    let(:feeder) { FeedMessenger.new(options) }

    it 'returns the correct instance variables' do
      allow(Thread).to receive(:new) do
      end
      expect(feeder.instance_variable_get(:@urls)).to eq urls
      expect(feeder.bot).to eq(bot)
      expect(feeder.config).to eq(config)
    end
  end
end
