require_relative '../decoder'

describe Decoder do
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

  describe '#decode' do
    it 'returns the properly encoded message' do
      expect(Decoder.new(key: key, code: code).decode).to eq(message)
      expect(Decoder.new(key: key2, code: code2).decode).to eq(message2)
      expect(Decoder.new(key: key3, code: code3).decode).to eq(message3)
      expect(Decoder.new(key: key4, code: code4).decode).to eq(message4)
    end
  end
end
