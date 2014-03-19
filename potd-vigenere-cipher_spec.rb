require_relative 'potd-vigenere-cipher'

describe "VigenereCipher" do

  let(:key_single_letter) { "r" }
  let(:message_single_letter) { "t" }
	let(:key) { "reddit" }
	let(:message) { "todayismybirthday" }
  let(:code) { "ksgdgbjqbeqkklgdg" }
	let(:key2) { "kurtrussell" }
	let(:message2) { "breakdownwasawesome" }
  let(:code2)    { "llvtbxgorhlcunxjiew" }
  let(:key3) { "aazzaazzxx" }
  let(:message3) { "zzjzaajzzyxppq" }
  let(:code3) { "zziyaaiywvxpop" }
  let(:key4) { "day" }
  let(:message4) { "welcometoproblemoftheday" }
  let(:code4) { "zejfokhtmsrmelcpodwhcgaw" }

  describe "Setter Methods" do
    before(:each) { @cipher = VigenereCipher.new } 

    describe "#key and #message" do
      before do
        @cipher.key = key
        @cipher.message = message
      end

      it "parses the #key and #message to only include letters" do
        @cipher.key = "a&&*()(&^%$$#%$%&*(*aaaa11223344''''''''aabbcc"
        @cipher.message = "eebbccdd039324834;;.,..//\//r"
        expect(@cipher.key).to eq("aaaaaaabbcc")
        expect(@cipher.message).to eq("eebbccddr")
      end

      it "nils @code if changing an instance variable after @key and @message are set" do
        @cipher.message = message2
        expect(@cipher.instance_variable_get(:@code)).to be_nil
      end

    end
  end

  describe "Getter Methods" do
    describe "#key" do

      context "when key is present" do
        before do
          @cipher = VigenereCipher.new
          @cipher.key = key2
        end

        it "returns the set value" do
          expect(@cipher.key).to eq(key2)
        end
      end

      context "when key is nil and message and code are present" do
        before do
          @cipher = VigenereCipher.new
          @cipher.message = message2
          @cipher.code = code2
        end
        it "returns the calculated value for the key" do
          expect(@cipher.key).to eq(VigenereCipher.cycle(key2, message2) )
        end

      end
    end

    describe "#message" do
      before(:each) do
        @cipher = VigenereCipher.new(key2, nil)
      end

      context "when message is present" do
        before { @cipher.message = message2 }
        it "returns the set value" do
          expect(@cipher.message).to eq(message2)
        end
      end

      context "when message is nil and key and code are present" do
        before do
          @cipher.key = key2
          @cipher.code = code2
        end
        
        it "returns the calculated value" do
          expect(@cipher.message = message2)
        end
      end
    end

    describe "#code" do
      before(:each) do
        @cipher = VigenereCipher.new
      end

      context "when key and message are present" do
        before do
          @cipher.key = key2
          @cipher.message = message2
        end
        
        it "returns the calculated value" do
          expect(@cipher.code).to eq("llvtbxgorhlcunxjiew")
        end
      end

      context "when key and message are nil" do
        it "asks for the user to enter a key and message" do
          @cipher.stub(:gets).and_return("#{key2}\n", "#{message2}\n")
          expect(@cipher.key).to eq(key2)
          expect(@cipher.message).to eq(message2)
          expect(@cipher.code).to eq(code2)
        end
      end
      
      context "when key is present and message is nil" do
        before do
          @cipher.key = key2
        end

        it "asks for the user to enter a message" do
          @cipher.stub(:gets).and_return("#{message2}\n")
          expect(@cipher.key).to eq(key2)
          expect(@cipher.message).to eq(message2)
          expect(@cipher.code).to eq(code2)
        end
      end

      context "when key is nil and message is present" do
        before do
          @cipher.message = message2
        end

        it "asks for the user to enter a key" do
          @cipher.stub(:gets).and_return("#{key2}\n")
          expect(@cipher.key).to eq(key2)
          expect(@cipher.message).to eq(message2)
          expect(@cipher.code).to eq(code2)
        end
      end
    end
  end

  describe "Class methods" do
    describe ".cycle" do
      let(:response) { VigenereCipher.cycle(key, message) }
      
      it "cycles through the key until its length == message.length" do
        expect(response).to eq ("redditredditreddi")
      end
    end

    describe ".get_code" do
      subject { VigenereCipher.get_code(key, message) }
      it {should eq(code) }
    end

    describe ".get_key" do
      subject { VigenereCipher.get_key(message2, code2) }
      it {should eq(VigenereCipher.cycle(key2, message2)) }
    end

    describe ".get_message" do
      it "should return the proper message" do
        expect(VigenereCipher.get_message(key, code)).to eq(message)
        expect(VigenereCipher.get_message(key2, code2)).to eq(message2)
        expect(VigenereCipher.get_message(key3, code3)).to eq(message3)
      end
    end
  end

  describe "Cracking methods" do
    describe ".crack" do
      it "returns something" do
        expect(VigenereCipher.crack(code4)).to eq({ key4 => message4 })
        expect(VigenereCipher.crack(code2)).to eq({ key2 => message2 })
        expect(VigenereCipher.crack(code)).to eq({ key => message })
      end 
    end

    describe ".words_and_messages" do
      let(:dictionary) { Dictionary.new('/usr/share/dict/wordsmall') }
      before(:all) { @words_and_messages = VigenereCipher.words_and_messages(code2, dictionary) }
      it "creates a hash" do
        expect(@words_and_messages).to be_a Hash
      end
      
      it "contains a message for every word in the dictionary" do
        expect(@words_and_messages.count).to eq(dictionary.all_words.count)
      end

    end
  end
end

describe "Dictionary" do
  file =  "/usr/share/dict/words"
  before(:all) { @words = Dictionary.new(file) }
  subject { @words }

  it { should respond_to :all_words }
  it { should respond_to :words_by_size }

  describe "#all_words" do
    subject { @words.all_words }
    it { should be_a Array }
    its(:count) { should eq(71671) }
  end

  describe "#words_by_size" do
    subject { @words.words_by_size(3,25) }
    it { should be_a Array }
    its(:count) { should eq(71621) }
  end
end
