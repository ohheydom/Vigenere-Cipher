#  Vigenere Cipher requires a key and a message. It works like this:
#
#  Key:
#      REDDIT
#  Message:
#      TODAYISMYBIRTHDAY
#
#   REDDITREDDITREDDI
#   TODAYISMYBIRTHDAY
#   -----------------
#   ksgdgbjqbeqkklgdg
#
#  Using a 0 based alphabet (A=0), R is the 17th letter of the alphabet and
#  T is the 19th letter of the alphabet. (17 + 19) mod 26 = 11 which is where
#  K resides in the alphabet. Repeat for each key/message letter combination
#  until done.
#
#  Today's problem of the day is two part. The first part is to implement
#  a Vigenère cipher in the programming language of your choice. Feel free
#  to post solutions or links to solutions in the comments.
#
#  The second part is to try and implement something to crack the message
#  below (the key is 5 or less characters).
#
#  zejfokhtmsrmelcpodwhcgaw

require_relative 'dictionary'

class VigenereCipher
  LETTERS = ('a'..'z').to_a
  ONLY_LETTERS_GSUB = /[^a-zA-Z]/
  DICTIONARY_FILE = 'words' # UNIX has a great dictionary file located at /usr/share/dict/words

  def initialize(key = nil, message = nil)
    @key = key ? key.gsub(ONLY_LETTERS_GSUB, '').downcase : nil
    @message = message ? message.gsub(ONLY_LETTERS_GSUB, '').downcase : nil
  end

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
        @key = please_enter('key')
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
        VigenereCipher.crack(@code, Dictionary.new(DICTIONARY_FILE), 12)
      else
        @message = please_enter('message')
      end
    end
  end

  def code=(code)
    if @key && @message
      puts 'You cannot modify the code. If you are trying to crack a code without a key or message, use VigenereCipher.crack(code)'
    else
      @code = code.gsub(ONLY_LETTERS_GSUB, '')
    end
  end

  def code
    if @code || @key && @message
      @code
    elsif @key.nil? && @message.nil?
      @key = please_enter('key')
      @message = please_enter('message')
    elsif @message.nil?
      @message = please_enter('message')
    elsif @key.nil?
      @key = please_enter('key')
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
      key.each_index.each_with_object('') { |ind, obj| obj << LETTERS[(LETTERS.index(key[ind]) + LETTERS.index(message[ind])) % 26] }
    end

    def get_message_or_key(key, code)
      key = cycle(key, code).chars
      key.each_index.each_with_object('') { |ind, obj| obj << LETTERS[(LETTERS.index(code[ind]) % 26) - (LETTERS.index(key[ind]))] }
    end

    def cycle(key, message)
      new_key = ''

      key.chars.cycle do |letter|
        new_key << letter
        break if new_key.length == message.length
      end

      new_key
    end

    def words_and_messages(code, dictionary, max_key_size)
      dictionary.words_by_size(3, max_key_size).each_with_object({}) do |word, obj|
        obj[word] = get_message_or_key(word, code)
      end
    end

    def reject_and_accept_words(all_words, keys_and_msgs)
      all_words.reject! { |word| keys_and_msgs.values.grep(/#{word}/).empty? }
      reg = "(#{Regexp.union(all_words)})"
      vals = keys_and_msgs.values.grep(/^(#{reg})+$/)
      vals.each_with_object({}) { |val, obj| obj[keys_and_msgs.key(val)] = val }
    end

    def crack(code, dictionary, max_key_size)
      puts 'Cracking...'
      all_words = dictionary.all_words.dup
      keys_and_msgs = words_and_messages(code.downcase, dictionary, max_key_size)
      reject_and_accept_words(all_words, keys_and_msgs)
    end
  end
end
