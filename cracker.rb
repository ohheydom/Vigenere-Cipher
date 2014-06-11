class Cracker
  def initialize(args)
    @dictionary = args[:dictionary] || Dictionary
    @code = args[:code]
  end
end
