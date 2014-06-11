class Encoder
  attr_accessor :key, :message
  LETTERS = ('a'..'z').to_a

  def initialize(args)
    @key = args[:key]
    @message = args[:message]
  end

  def encode
    new_key = cycle.chars
    new_key.each_index.each_with_object('') { |ind, obj| obj << LETTERS[(LETTERS.index(new_key[ind]) + LETTERS.index(message[ind])) % 26] }
  end

  def cycle
    new_key = ''

    key.chars.cycle do |letter|
      new_key << letter
      break if new_key.length == message.length
    end

    new_key
  end
end
