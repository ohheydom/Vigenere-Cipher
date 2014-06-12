require_relative '../vigenere_cipher'

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
  let(:key4) { 'day' }
  let(:message4) { 'welcometoproblemoftheday' }
  let(:code4) { 'zejfokhtmsrmelcpodwhcgaw' }

  describe '#decode' do
    it 'returns the proper message' do
      expect(VigenereCipher.new.decode(key, code)).to eq(message)
    end
  end

  describe '#encode' do
    it 'returns the code' do
      expect(VigenereCipher.new.encode(key, message)).to eq(code)
    end
  end

  describe '#crack' do
    it 'returns the decoded message' do
      expect(VigenereCipher.new.crack(code2)).to eq(key2 => message2)
      expect(VigenereCipher.new.crack(code4)).to eq(key4 => message4)
    end
  end
end
