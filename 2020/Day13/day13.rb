# frozen_string_literal: true

require 'basic_file_reader'

input = BasicFileReader.lines(file_name: 'input')

# Part 1
def find_earliest_bus(timestamp, busses)
  waiting_times = {}

  busses.each do |bus|
    waiting_times[bus] = bus - timestamp % bus
  end

  waiting_times.min_by { |_, v| v }
end

timestamp = input[0].to_i
busses = input[1].split(',').reject { |bid| bid == 'x' }.map(&:to_i)

bus_id, time_to_wati = find_earliest_bus(timestamp, busses)
p bus_id * time_to_wati

# Part 2
# Encapsulates the logic the CRT
# Ref: https://www.youtube.com/watch?v=zIFehsBHB8o&ab_channel=MathswithJay
class ChineseRemainderTheorem
  def initialize(busses)
    @remainders = []
    @mods = []
    @mods_product = 1
    @partial_mods_products = []
    @partial_results = []

    init_from_busses(busses)
    compute_partials
  end

  def solution
    result = 0
    @mods.each_with_index do |_, index|
      result += @remainders[index] * @partial_mods_products[index] * @partial_results[index]
    end

    result % @mods_product
  end

  private

  def init_from_busses(busses)
    busses.each_with_index do |bus, index|
      next if bus == 'x'

      bus = bus.to_i
      @mods << bus
      @remainders << -index % bus
      @mods_product *= bus
    end
  end

  def compute_partials
    @mods.each do |mod|
      @partial_mods_products << @mods_product / mod
      @partial_results << inverse_of(@partial_mods_products.last, mod)
    end
  end

  def inverse_of(partial_mod_product, mod)
    partial_result = 1
    partial_result += 1 until (partial_mod_product * partial_result) % mod == 1
    partial_result
  end
end

busses = input[1].split(',')
p ChineseRemainderTheorem.new(busses).solution
