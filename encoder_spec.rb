require_relative 'encoder'

describe Encoder do
  let(:key) { 'reddit' }
  let(:message) { 'todayismybirthday' }
  let(:code) { 'ksgdgbjqbeqkklgdg' }
  let(:key2) { 'kurtrussell' }
  let(:message2) { 'breakdownwasawesome' }
  let(:code2)    { 'llvtbxgorhlcunxjiew' }
  let(:key3) { 'aazzaazzxx' }
  let(:message3) { 'zzjzaajzzyxppq' }
  let(:code3) { 'zziyaaiywvxpop' }
  let(:key4) { 'day' }
  let(:message4) { 'welcometoproblemoftheday' }
  let(:code4) { 'zejfokhtmsrmelcpodwhcgaw' }

  describe '#cycle' do
    it 'cycles the key until its length is equivalent to the message' do
      expect(Encoder.new(key: key, message: message).cycle).to eq('redditredditreddi')
    end
  end

  describe '#encode' do
    it 'returns the properly encoded message' do
      expect(Encoder.new(key: key, message: message).encode).to eq(code)
      expect(Encoder.new(key: key2, message: message2).encode).to eq(code2)
      expect(Encoder.new(key: key3, message: message3).encode).to eq(code3)
      expect(Encoder.new(key: key4, message: message4).encode).to eq(code4)
    end
  end
end
