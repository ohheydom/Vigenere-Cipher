require_relative 'vigenere_cipher'

describe 'VigenereCipher' do
  DICTIONARY_FILE = 'words'
  let(:key_single_letter) { 'r' }
  let(:message_single_letter) { 't' }
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

  describe 'Class methods' do
    describe '.cycle' do
      let(:response) { VigenereCipher.cycle(key, message) }

      it 'cycles through the key until its length == message.length' do
        expect(response).to eq('redditredditreddi')
      end
    end
  end

  describe 'Cracking methods' do
    describe '.crack' do
      dictionary = Dictionary.new(DICTIONARY_FILE)
      it 'returns a message' do
        expect(VigenereCipher.crack(code4, dictionary, 12)).to eq(key4 => message4)
        expect(VigenereCipher.crack(code2, dictionary, 12)).to eq(key2 => message2)
        expect(VigenereCipher.crack(code, dictionary, 12)).to eq(key => message)
      end
    end

    describe '.words_and_messages' do
      dictionary = Dictionary.new(DICTIONARY_FILE)
      subject { VigenereCipher.words_and_messages(code2, dictionary, 14) }

      it { should be_a Hash }
      it { should include(key2 => message2) }
    end
  end
end
