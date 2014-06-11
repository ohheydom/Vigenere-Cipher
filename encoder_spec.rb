require_relative 'encoder'

describe Encoder do
  let(:key) { 'reddit' }
  let(:message) { 'todayismybirthday' }
  let(:code) { 'ksgdgbjqbeqkklgdg' }

  describe '#cycle' do
    it 'cycles the key until its length is equivalent to the message' do
      expect(Encoder.new(key: key, message: message).cycle).to eq('redditredditreddi')
    end
  end

  describe '#encode' do
    it 'returns the properly encoded message' do
      expect(Encoder.new(key: key, message: message).encode).to eq(code)
    end
  end
end
