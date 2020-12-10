# frozen_string_literal: true

require 'basic_file_reader'

adapters = BasicFileReader.lines(file_name: 'input').map(&:to_i).sort

# Monkeypatch the [] for arrays so that the default value for an array will
#   be 0 instad of nil; this way we don't need to add .to_i or exatra checks
class Array
  def [](index)
    at(index) || 0
  end
end

def joltages(adapters)
  diffs = [0, 0, 1]
  current_jolt = 0

  adapters.each do |adapter|
    diffs[adapter - current_jolt - 1] += 1
    current_jolt = adapter
  end

  diffs[0] * diffs[2]
end

def adapters_arrangements(adapters)
  arrangements = []

  arrangements[adapters.size - 1] = 1

  (adapters.size - 2).downto(0).each do |index|
    arrangements[index] = 0
    (index + 1).upto(index + 3) do |i|
      next if adapters[i] - adapters[index] > 3

      arrangements[index] += arrangements[i]
    end
  end

  arrangements.first
end

p joltages(adapters)
p adapters_arrangements([0] + adapters + [adapters.max + 3])
