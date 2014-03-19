#Vigenere Cipher requires a key and a message. It works like this:
#
#  Key:
#      REDDIT
#Message:
#      TODAYISMYBIRTHDAY
#
#   REDDITREDDITREDDI
#   TODAYISMYBIRTHDAY
#   -----------------
#   ksgdgbjqbeqkklgdg
#
#Using a 0 based alphabet (A=0), R is the 17th letter of the alphabet and T is the 19th letter of the alphabet. (17 + 19) mod 26 = 11 which is where K resides in the alphabet. Repeat for each key/message letter combination until done.
#
#  Today's problem of the day is two part. The first part is to implement a Vigenère cipher in the programming language of your choice. Feel free to post solutions or links to solutions in the comments.
#
#  The second part is to try and implement something to crack the message below (the key is 5 or less characters).
#
#  zejfokhtmsrmelcpodwhcgaw

class VigenereCipher
  
  LETTERS = ('a'..'z').to_a
  ONLY_LETTERS_GSUB = /[^a-zA-Z]/
  DICTIONARY_FILE = "words" #UNIX has a great dictionary file located at /usr/share/dict/words

  def initialize(key=nil, message=nil)
    @key = key ? key.gsub(ONLY_LETTERS_GSUB, '').downcase : nil
    @message = message ? message.gsub(ONLY_LETTERS_GSUB, '').downcase : nil
  end

  #Setter methods with validation
  [:key, :message].each do |attr|
    define_method("#{attr}=") do |val|
      @code = nil if instance_variable_get("@#{attr}")
      instance_variable_set("@#{attr}", val.gsub(ONLY_LETTERS_GSUB, '').downcase)
    end
  end

  def key
    if @key
      @key
    else
      if @message && @code
        @key = VigenereCipher.get_message_or_key(@message, @code)
      else
        @key = please_enter("key")
      end
    end
  end

  def message
    if @message
      @message
    else
      if @key && @code
        @message = VigenereCipher.get_message_or_key(@key, @code)
      elsif @code
        VigenereCipher.crack(@code)
      else
        @message = please_enter("message")
      end
    end
  end

  def code=(code)
    if @key && @message
      puts "You cannot modify the code. If you are trying to crack a code without a key or message, use VigenereCipher.crack(code)"
    else
      @code = code.gsub(ONLY_LETTERS_GSUB, '')
    end
  end

  def code
    if @code || @key && @message
      @code
    elsif @key.nil? && @message.nil?
      @key = please_enter("key")
      @message = please_enter("message")
    elsif @message.nil?
      @message = please_enter("message")
    elsif @key.nil?
      @key = please_enter("key")
    end

    @code ||= VigenereCipher.get_code(@key, @message)

  end

  def clear
    @key, @message, @code = nil
  end

  private

  def please_enter(variable_name)
    puts "Please enter a #{variable_name}: "
    gets.chomp.gsub(ONLY_LETTERS_GSUB, '').downcase
  end
  
  class << self

  def get_code(key, message)
    key = cycle(key, message).chars
    key.each_index.each_with_object("") { |ind, obj| obj << LETTERS[(LETTERS.index(key[ind]) + LETTERS.index(message[ind])) % 26] }
  end


  def get_message_or_key(key, code)
    key = cycle(key, code).chars
    key.each_index.each_with_object("") { |ind, obj| obj << LETTERS[(LETTERS.index(code[ind]) % 26) - (LETTERS.index(key[ind]))] }
  end

  def cycle(key, message)
    new_key = ""
  
    key.chars.cycle do |letter| 
      new_key << letter
      break if new_key.length == message.length
    end
  
    new_key
  end

  def words_and_messages(code, dictionary, max_key_size)
    dictionary.words_by_size(3,max_key_size).each_with_object({}) { |word, obj| obj[word] = get_message_or_key(word, code) }
  end

  def crack(code, max_key_size)
    puts "Cracking..."

    dictionary = Dictionary.new(DICTIONARY_FILE)
    all_words = dictionary.all_words.dup
    keys_and_msgs = words_and_messages(code.downcase, dictionary, max_key_size)
    messages = keys_and_msgs.values
    all_words.reject! { |word| messages.grep(/#{word}/).empty? }
    reg = "(#{Regexp.union(all_words)})"
    poss_keys_and_msgs = {}


    (0..6).to_a.each do |num|
      check_values_proc = Proc.new do |word| 
        keys_and_msgs.values.grep(/^#{word}#{reg*num}$/).each {|val| poss_keys_and_msgs[keys_and_msgs.key(val)] ||= val } 
      end

      all_words.reject! { |beg| messages.grep(/^(#{beg})#{reg*num}/).empty? }
      if all_words.count > 1
        temp = all_words.reject { |beg| messages.grep(/^(#{beg})#{reg*num}$/).empty? }
        temp ? temp.each(&check_values_proc) : next
      else
        all_words.each(&check_values_proc)
      end
    end

    poss_keys_and_msgs
  end

  end
end


  class Dictionary

    EXTRA_WORDS = %w(a i is as at be ed he ho in it jo jr la re ok mo mr si sr st no my me ma if 
                     hi ha go ex do db by ax an of oh or ow ox pi so to uh um up us vs we yo)

    def initialize(file)
      @word_list = File.read(file).downcase
    end

    def all_words
      @all_words ||= (@word_list.scan(/^\w{3,}$/) + EXTRA_WORDS).uniq #Using \w+ instead of \s+ because we don't want words with apostrophes or other strange characters
    end

    def words_by_size(min, max)
      @word_list.scan(/^\w{#{min},#{max}}$/).uniq
    end

  end
