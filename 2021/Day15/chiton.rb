require 'basic_file_reader'
require 'Set'
require 'pqueue'

class Maze
  def initialize
    @matrix = BasicFileReader.lines(file_name: 'input') { |line| line.split('').map(&:to_i) }
  end

  def path_total_risk
    find_path(@matrix)
  end

  def full_path_total_risk
    find_path(expanded_matrix)
  end

  private

  def find_path(matrix)
    queue = init_queue
    goal = [matrix[0].size - 1, matrix.size - 1]
    visited = Set[]

    until queue.empty?
      position, risk = queue.pop

      next unless visited.add?(position)
      return risk if position == goal

      each_neighbour(matrix, position) { |x, y| queue.push([[x, y], risk + matrix[y][x]]) }
    end
  end

  def init_queue
    PQueue.new([[[0, 0], 0]]) { |a, b| a.last < b.last }
  end

  def expanded_matrix
    @expanded_matrix ||= 5.times.flat_map do |y_expansion|
      @matrix.map do |row|
        5.times.flat_map do |x_expansion|
          row.map do |cell|
            new_cell = cell + y_expansion + x_expansion
            new_cell -= 9 until new_cell <= 9
            new_cell
          end
        end
      end
    end
  end

  def each_neighbour(grid, (x, y))
    yield [x, y - 1] if y.positive?
    yield [x + 1, y] if x + 1 < grid[y].size
    yield [x, y + 1] if y + 1 < grid.size
    yield [x - 1, y] if x.positive?
  end
end

maze = Maze.new
p maze.path_total_risk
p maze.full_path_total_risk
