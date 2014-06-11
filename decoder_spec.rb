require_relative 'decoder'

describe Decoder do
  let(:key) { 'reddit' }
  let(:message) { 'todayismybirthday' }
  let(:code) { 'ksgdgbjqbeqkklgdg' }

  describe '#decode' do
    it 'returns the properly encoded message' do
      expect(Decoder.new(key: key, code: code).decode).to eq(message)
    end
  end
end
