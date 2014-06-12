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
  let(:key3) { 'aazzaazzxx' }
  let(:message3) { 'zzjzaajzzyxppq' }
  let(:code3) { 'zziyaaiywvxpop' }
  let(:key4) { 'day' }
  let(:message4) { 'welcometoproblemoftheday' }
  let(:code4) { 'zejfokhtmsrmelcpodwhcgaw' }
end
