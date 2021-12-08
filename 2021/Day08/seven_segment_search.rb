require 'basic_file_reader'

class Pair
  attr_accessor :inputs, :outputs

  def initialize(*args)
    @inputs = args[0]
    @outputs = args[1]
    @values = inputs + outputs
  end

  def output_score
    @outputs.map do |output|
      mappings[output.split('').sort]
    end.join.to_i
  end

  private

  def mappings
    @mappings ||=
      { zero => 0, one => 1, two => 2, three => 3, four => 4, five => 5, six => 6, seven => 7, eight => 8, nine => 9 }
  end

  def zero
    @zero ||= @values.find { |value| value.size == 6 && (value.split('') - five).size == 2 }.split('').sort
  end

  def one
    @one ||= @values.find { |value| value.size == 2 }.split('').sort
  end

  def two
    @two ||= @values.find { |value| value.size == 5 && (nine - value.split('')).size == 2 }.split('').sort
  end

  def three
    @three ||= @values.find { |value| value.size == 5 && (two - value.split('')).size == 1 }.split('').sort
  end

  def four
    @four ||= @values.find { |value| value.size == 4 }.split('').sort
  end

  def five
    @five ||= @values.find { |value| value.size == 5 && (two - value.split('')).size == 2 }.split('').sort
  end

  def six
    @six ||= @values.find do |value|
      value.size == 6 && !(value.split('') - zero).empty? && !(value.split('') - nine).empty?
    end.split('').sort
  end

  def seven
    @seven ||= @values.find { |value| value.size == 3 }.split('').sort
  end

  def eight
    @eight ||= @values.find { |value| value.size == 7 }.split('').sort
  end

  def nine
    @nine ||= @values.find { |value| value.size == 6 && (value.split('') - four).size == 2 }.split('').sort
  end
end

class SevenSegmentDisplay
  attr_reader :pairs

  def initialize
    @pairs = []

    BasicFileReader.lines(file_name: 'input') do |line|
      pairs << Pair.new(*line.split(' | ').map { |el| el.split(' ') })
    end
  end

  def digits_with_unique_segments_number
    pairs.inject(0) do |sum, pair|
      sum + pair.outputs.select { |output| [2, 4, 3, 7].include?(output.size) }.size
    end
  end

  def outputs_sum
    pairs.map(&:output_score).reduce(:+)
  end
end

display = SevenSegmentDisplay.new
p display.digits_with_unique_segments_number
p display.outputs_sum
