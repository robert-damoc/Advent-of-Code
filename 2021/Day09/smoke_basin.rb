require 'basic_file_reader'

class SmokeBasin
  attr_reader :lines

  def initialize
    @lines = BasicFileReader.lines(file_name: 'input') { |line| line.split('').map(&:to_i) }
    @low_points_index = []
    @largest_basins = []

    search_low_points
    search_largest_basins
  end

  def sum_of_low_points_risk_level
    @low_points_index.inject(0) { |sum, (line_index, col_index)| sum + lines[line_index][col_index] + 1 }
  end

  def product_of_largest_basins_sizes(basins_count: 3)
    @largest_basins.sort.last(basins_count).reduce(1, :*)
  end

  private

  def search_largest_basins
    @low_points_index.each do |(line_index, col_index)|
      @largest_basins << basin_size(lines.map(&:dup), line_index, col_index)
    end
  end

  def basin_size(matrix, line_index, col_index)
    return 0 if line_index.negative? || col_index.negative?
    return 0 if matrix.dig(line_index, col_index).nil?
    return 0 if matrix[line_index][col_index] >= 9

    sum = 1
    matrix[line_index][col_index] = 9

    sum += basin_size(matrix, line_index, col_index - 1)
    sum += basin_size(matrix, line_index, col_index + 1)
    sum += basin_size(matrix, line_index - 1, col_index)
    sum += basin_size(matrix, line_index + 1, col_index)

    sum
  end

  def search_low_points
    0.upto(lines.size - 1) do |line_index|
      0.upto(lines[line_index].size - 1) do |col_index|
        if lines[line_index][col_index] < cell_neighbours(line_index, col_index).min
          @low_points_index << [line_index, col_index]
        end
      end
    end
  end

  def cell_neighbours(line_index, col_index, matrix: lines)
    neighbours = [matrix.dig(line_index, col_index + 1), matrix.dig(line_index + 1, col_index)]
    neighbours << matrix.dig(line_index, col_index - 1) unless (col_index - 1).negative?
    neighbours << matrix.dig(line_index - 1, col_index) unless (line_index - 1).negative?

    neighbours.compact
  end
end

smoke_basin = SmokeBasin.new
p smoke_basin.sum_of_low_points_risk_level
p smoke_basin.product_of_largest_basins_sizes
