require_relative '../dictionary'

describe Dictionary do
  DICTIONARY_FILE = 'words'
  before(:all) { @words = Dictionary.new(DICTIONARY_FILE) }
  subject { @words }

  describe '#all_words' do
    subject { @words.all_words }
    it { should be_a Array }
    its(:count) { should eq(File.read(DICTIONARY_FILE).scan(/^\w{3,}$/).count + Dictionary::EXTRA_WORDS.count) }

    it 'does not return any strings less than 3 characters' do
      expect((@words.all_words.grep(/^\w{1,2}$/) - Dictionary::EXTRA_WORDS).count).to eq(0)
    end
  end

  describe '#words_by_size' do
    subject { @words.words_by_size(3, 25) }
    it { should be_a Array }
    its(:count) { should eq((File.read(DICTIONARY_FILE).scan(/^\w{3,}$/)) .count) }

    it 'does not return any strings less than 3 characters' do
      x = 3
      expect(@words.words_by_size(x, 10).grep(/^\w{1,#{x - 1}}$/).count).to eq(0)
    end
  end
end
