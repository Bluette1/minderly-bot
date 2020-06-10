require_relative '../lib/message_sender'

describe MessageSender do
    let(:bot) {{}}

    describe '#initialise' do
        let(:options) {{bot: bot, text: 'message', chat:{}}}
        let(:sender) { MessageSender.new(options)}

        it 'returns the correct instance variables' do
            expect(sender.instance_variable_get(:@text)).to eq ('message')
            expect(sender.instance_variable_get(:@chat)).to eq ({})
            expect(sender.bot).to eq(bot)     
        end
    end   
end