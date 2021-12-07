require 'basic_file_reader'

class Crabs
  attr_reader :positions

  def initialize
    @positions = BasicFileReader.content(file_name: 'input').split(',').map(&:to_i)
  end

  def alignment_fuel_with_median
    positions.map { |position| (position - median).abs }.reduce(:+)
  end

  def alignment_fuel_with_mean
    ceil_mean = sum_for_mean(mean.ceil)
    floor_mean = sum_for_mean(mean.floor)

    [ceil_mean, floor_mean].min
  end

  private

  def sum_for_mean(modified_mean)
    positions.map { |position| (position - modified_mean).abs }.inject(0) do |sum, pos|
      sum + (pos * (pos + 1) / 2)
    end
  end

  def mean
    @mean ||= positions.sum(0.0) / positions.size
  end

  def median
    @median ||= begin
      sorted_positions = positions.sort
      mid_point = sorted_positions.size / 2

      if positions.size.even?
        sorted_positions[mid_point - 1, 2].sum / 2
      else
        sorted_positions[mid_point]
      end
    end
  end
end

crabs = Crabs.new
p crabs.alignment_fuel_with_median
p crabs.alignment_fuel_with_mean
