# frozen_string_literal: true

require 'basic_file_reader'

# This will handle the mask and memory functionality for part 1
class Program
  attr_reader :mask, :mem

  def initialize
    @mem = {}
    @mask = nil

    read_data
    init_data

    @lines = nil
  end

  def memory_sum
    @mem.values.reduce(0, &:+)
  end

  private

  def init_data
    res_index_regex = /\d+/

    @lines.each do |line|
      res, value = line.split(' = ')

      case res
      when 'mask'
        @mask = value
      else
        @mem[res[res_index_regex].to_i] = masked_value(value.to_i)
      end
    end
  end

  def masked_value(value)
    value.to_s(2)
         .rjust(@mask.length, '0')
         .chars
         .zip(@mask.chars)
         .map { |value_char, mask_char| mask_char == 'X' ? value_char : mask_char }
         .join
         .to_i(2)
  end

  def read_data
    @lines = BasicFileReader.lines(file_name: 'input')
  end
end

p Program.new.memory_sum
