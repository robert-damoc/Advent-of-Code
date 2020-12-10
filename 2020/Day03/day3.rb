require 'basic_file_reader'

class Matrix
  EMPTY_SPACE = '.'.freeze
  BLOCKED_SPACE = '#'.freeze

  attr_reader :rows

  def initialize
    @rows = []

    BasicFileReader.lines(file_name: 'input').each do |line|
      rows << line
    end
  end

  def blocked_spaces(column_padding, row_padding)
    blocks = 0

    current_column_index = 0
    current_row_index = 0

    loop do
      current_column_index = (current_column_index + column_padding) % rows[0].size
      current_row_index += row_padding

      blocks += 1 if rows[current_row_index][current_column_index] == BLOCKED_SPACE

      break if current_row_index >= @rows.size - 1
    end

    blocks
  end
end

matrix = Matrix.new

# First part
p matrix.blocked_spaces(3, 1)

# Second Part
puts([[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].inject(1) do |total, (col, row)|
  total * matrix.blocked_spaces(col, row)
end)
