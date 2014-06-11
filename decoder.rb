class Decoder
  attr_accessor :key, :code
  LETTERS = ('a'..'z').to_a

  def initialize(args)
    @key = args[:key]
    @code = args[:code]
  end

  def decode
    new_key = cycle.chars
    new_key.each_index.each_with_object('') { |ind, obj| obj << LETTERS[(LETTERS.index(code[ind]) % 26) - (LETTERS.index(new_key[ind]))] }
  end

  def cycle
    new_key = ''

    key.chars.cycle do |letter|
      new_key << letter
      break if new_key.length == code.length
    end

    new_key
  end
end
