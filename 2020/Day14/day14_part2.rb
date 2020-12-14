# frozen_string_literal: true

require 'basic_file_reader'

# This will handle the mask and memory functionality for part 2
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
    @lines.each do |line|
      res, value = line.split(' = ')

      case res
      when 'mask'
        @mask = value
      else
        handle_memory_updates(res[/\d+/].to_i, value.to_i)
      end
    end
  end

  def handle_memory_updates(index, value)
    masked_index = masked_binary_value(index)

    expanded_value(masked_index).each do |mem_index|
      @mem[mem_index] = value
    end
  end

  def expanded_value(masked_value)
    floating_indices = []
    masked_value.each_char.with_index { |ch, i| floating_indices << i if ch == 'X' }

    index_products = floating_indices.map { |index| [index].product(%w[0 1]) }
    index_products.first.product(*index_products[1..]).map do |combination|
      expanded_mem_value = masked_value.dup
      combination.each { |index, value| expanded_mem_value[index] = value }
      expanded_mem_value
    end
  end

  def masked_binary_value(value)
    value.to_s(2)
         .rjust(@mask.length, '0')
         .chars
         .zip(@mask.chars)
         .map { |value_char, mask_char| mask_char == '0' ? value_char : mask_char }
         .join
  end

  def read_data
    @lines = BasicFileReader.lines(file_name: 'input')
  end
end

p Program.new.memory_sum
