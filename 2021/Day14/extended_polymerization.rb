require 'basic_file_reader'

class ExtendedPolymerization
  attr_reader :polymer, :rules

  def initialize
    lines = BasicFileReader.lines(file_name: 'input')

    @initial_polymer = lines[0]
    @rules = Hash[lines[2..].map { |line| line.split(' -> ') }]
  end

  def polymer_quantity_diff_after(steps: 10)
    reset_polymer

    steps.times { insert }

    char_frequency.values.minmax.reduce(:-).abs
  end

  private

  def char_frequency
    Hash.new(0).tap do |result|
      polymer.each do |k, v|
        result[k[0]] += v
        result[k[1]] += v
      end

      result.each { |k, v| result[k] = (v / 2.0).ceil }
    end
  end

  def insert
    new_polymer = Hash.new(0)

    polymer.each do |pair, count|
      new_polymer["#{pair[0]}#{rules[pair]}"] += count
      new_polymer["#{rules[pair]}#{pair[1]}"] += count
    end

    @polymer = new_polymer
  end

  def reset_polymer
    @polymer = Hash.new(0)

    array_polymer = @initial_polymer.split('')
    array_polymer.zip(array_polymer[1..])[...-1].map(&:join).each do |pair|
      @polymer[pair] += 1
    end
  end
end

extended_polymerization = ExtendedPolymerization.new
p extended_polymerization.polymer_quantity_diff_after
p extended_polymerization.polymer_quantity_diff_after(steps: 40)
