# frozen_string_literal: true

require 'basic_file_reader'
require 'ostruct'

# Class to handle de instructions
class BootSequence
  attr_reader :instructions

  def initialize
    @instructions = []

    BasicFileReader.lines(file_name: 'input') do |line|
      op, arg = line.split(' ')
      instructions << OpenStruct.new(operation: op, argument: arg.to_i, executed: false)
    end
  end

  def execute
    reset

    loop do
      break unless instructions[@index]

      if instructions[@index].executed
        @successful = false
        break
      end

      execute_operation(instructions[@index])
    end

    @accumulator
  end

  def fix_and_execute
    instructions.each do |instruction|
      next if instruction.operation == 'acc'

      switch_operation(instruction)
      result = execute

      return result if @successful

      switch_operation(instruction)
    end
  end

  private

  def execute_operation(instruction)
    instruction.executed = true

    case instruction.operation
    when 'acc'
      @accumulator += instruction.argument
    when 'jmp'
      @index += instruction.argument - 1
    end

    @index += 1
  end

  def switch_operation(instruction)
    instruction.operation = instruction.operation == 'nop' ? 'jmp' : 'nop'
  end

  def reset
    instructions.each { |ins| ins.executed = false }
    @accumulator = 0
    @index = 0
    @successful = true
  end
end

boot_seq = BootSequence.new

p boot_seq.execute
p boot_seq.fix_and_execute
