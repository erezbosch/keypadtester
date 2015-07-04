require 'keypad'

class KeypadTester
  def initialize(length, mode_keys)
    @length, @mode_keys = length, mode_keys
  end

  def run_simple
    test_pad = Keypad.new(@length, @mode_keys)
    codes = (0...(10 ** @length)).to_a.map do |num|
      num.to_s.rjust(@length, '0').split('').map(&:to_i)
    end
    presses = 0
    codes.each do |code|
      code.each do |digit|
        presses += 1
        test_pad.press(digit)
      end
      # to signal the end of the code entry
      test_pad.press(@mode_keys.sample)
      presses += 1
    end

    if test_pad.all_codes_entered?
      puts "all codes input"
      puts "presses: #{presses}"
      puts "repeated codes: #{test_pad.repeats}"
    end
  end

  def run_smart
    test_pad = Keypad.new(@length, @mode_keys)
    codes = (0...(10 ** @length)).to_a.map do |num|
      num.to_s.rjust(@length, '0').split('').map(&:to_i) + [@mode_keys.sample]
    end
    presses = 0
    sequence = codes.shift

    until codes.empty?
      last_code = sequence[-@length - 1..-1]
      codes.sort! {|a, b| in_common(last_code, b) <=> in_common(last_code, a)}
      code = codes.shift
      sequence += code[in_common(last_code, code)..-1]
    end

    sequence.each do |digit|
      test_pad.press(digit)
      presses += 1
    end

    if test_pad.all_codes_entered?
      puts "all codes input"
      puts "presses: #{presses}"
      puts "repeated codes: #{test_pad.repeats}"
    end
  end
  
  def in_common(code1, code2)
    count = code1.length
    while count > 0
      (code1[-count..-1] == code2[0..count - 1]) ? (return count) : (count -= 1)
    end
    return count
  end
end
