require_relative 'cracker'
require_relative 'dictionary'

describe Cracker do
  DICTIONARY_FILE = 'words'
  let(:key_single_letter) { 'r' }
  let(:message_single_letter) { 't' }
  let(:key) { 'reddit' }
  let(:message) { 'todayismybirthday' }
  let(:code) { 'ksgdgbjqbeqkklgdg' }
  let(:key2) { 'kurtrussell' }
  let(:message2) { 'breakdownwasawesome' }
  let(:code2)    { 'llvtbxgorhlcunxjiew' }
  let(:key4) { 'day' }
  let(:message4) { 'welcometoproblemoftheday' }
  let(:code4) { 'zejfokhtmsrmelcpodwhcgaw' }

  describe '#crack' do
    dictionary = Dictionary.new(DICTIONARY_FILE)
    it 'returns the proper message' do
      expect(Cracker.new(dictionary: dictionary, code: code).crack).to eq(key => message)
      expect(Cracker.new(dictionary: dictionary, code: code2).crack).to eq(key2 => message2)
      expect(Cracker.new(dictionary: dictionary, code: code4).crack).to eq(key4 => message4)
    end
  end

  describe '#words_and_messages' do
    subject { Cracker.new(code: code2).words_and_messages }

    it { should be_a Hash }
    it { should include(key2 => message2) }
  end
end
