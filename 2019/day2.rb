require 'basic_file_reader'

class Intcode
  def initialize
    @initial_instructions = BasicFileReader.content(file_name: './inputs/day2') do |content|
      content.strip.split(',').map(&:to_i)
    end
  end

  def task1
    @instructions = @initial_instructions.dup
    @instructions[1] = 12
    @instructions[2] = 2

    parse
  end

  def task2(desired_output)
    0.upto(99) do |noun|
      0.upto(99) do |verb|
        @instructions = @initial_instructions.dup
        @instructions[1] = noun
        @instructions[2] = verb

        return 100 * noun + verb if parse == desired_output
      end
    end
  end

  def parse
    opcode_index = 0
    loop do
      case @instructions[opcode_index]
      when 1
        opcode1(*@instructions[opcode_index + 1..opcode_index + 3])
      when 2
        opcode2(*@instructions[opcode_index + 1..opcode_index + 3])
      when 99
        return @instructions[0]
      else
        raise "Invalid OPCODE at: #{opcode_index}"
      end
      opcode_index += 4
    end
  end

  private

  def opcode1(op1_address, op2_address, result_address)
    @instructions[result_address] = @instructions[op1_address] + @instructions[op2_address]
  end

  def opcode2(op1_address, op2_address, result_address)
    @instructions[result_address] = @instructions[op1_address] * @instructions[op2_address]
  end
end

intcode = Intcode.new

puts intcode.task1              # 4_090_701
puts intcode.task2(19_690_720)  # 6_421
