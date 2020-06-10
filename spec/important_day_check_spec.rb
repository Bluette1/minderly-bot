require_relative '../lib/important_day_checker'

describe ImportantDayChecker do
    let(:bot) {{}}
    let(:config){{}}

    describe '#initialise' do
        let(:options) {{bot: bot, config: config}}
        let(:date_checker) { ImportantDayChecker.new(options)}

        it 'returns the correct instance variables' do
            expect(date_checker.bot).to eq(bot)
            expect(date_checker.config).to eq(config)
        end
    end   
end