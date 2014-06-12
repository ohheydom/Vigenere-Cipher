class Cracker
  attr_reader :code, :dictionary, :max_key_size
  LETTERS = ('a'..'z').to_a

  def initialize(args)
    @dictionary = args[:dictionary] || Dictionary.new('words')
    @code = args[:code]
    @max_key_size = args[:max_key_size] || 14
  end

  def cycle(key, message)
    new_key = ''

    key.chars.cycle do |letter|
      new_key << letter
      break if new_key.length == message.length
    end

    new_key
  end

  def decode(key, message)
    new_key = cycle(key, message).chars
    new_key.each_index.each_with_object('') do |ind, obj| 
      obj << LETTERS[(LETTERS.index(code[ind]) % 26) - (LETTERS.index(new_key[ind]))]
    end
  end

  def words_and_messages
    dictionary.words_by_size(3, max_key_size).each_with_object({}) do |word, obj|
      obj[word] = decode(word, code.downcase)
    end
  end

  def reject_and_accept_words(all_words, keys_and_msgs)
    all_words.reject! { |word| keys_and_msgs.values.grep(/#{word}/).empty? }
    reg = "(#{Regexp.union(all_words)})"
    vals = keys_and_msgs.values.grep(/^(#{reg})+$/)
    vals.each_with_object({}) { |val, obj| obj[keys_and_msgs.key(val)] = val }
  end

  def crack
    puts 'Cracking...'
    all_words = dictionary.all_words.dup
    reject_and_accept_words(all_words, words_and_messages)
  end
end
