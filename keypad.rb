class Keypad
  attr_reader :code_bank
  def initialize(length, mode_keys)
    @length = length
    @mode_keys = mode_keys
    @history = []
    @code_bank = {}
    (0...(10**length)).each do |num|
      @code_bank[num.to_s.rjust(length, "0").split('').map(&:to_i)] = 0
    end
  end

  def press(key)
    @history = @history.last(@length)
    if @history.length == @length && @mode_keys.include?(key)
      @code_bank[@history] += 1
    end
    @history << key
  end

  def all_codes_entered?
    @code_bank.values.all? { |v| v > 0 }
  end

  def repeats
    @code_bank.count { |k, v| v > 1 }
  end
end
