require 'basic_file_reader'

class WiresBoard
  attr_reader :board, :ox, :oy, :intersections

  def initialize
    @intersections = []

    @wire1, @wire2 = BasicFileReader.lines(file_name: './inputs/day3') do |line|
      line.split(',')
    end
    @wire1, @wire2 = ['R8,U5,L5,D3', 'U7,R6,D4,L4'].map { |z| z.split(',') }

    @ox, @oy = 20, 20
    @board = Array.new(50) { Array.new(50, '.') }

    board[oy][ox] = 'O'

    draw_wires
  end

  def closest_intersectin
    min_dist = Float::INFINITY

    @intersections.each do |x, y|
      dist = (ox - x).abs + (oy - y).abs
      min_dist = dist if min_dist > dist
    end

    min_dist
  end

  def to_s
    @board.each do |row|
      row.each do |cell|
        print cell
      end
      puts
    end
  end

  private

  def draw_wires
    draw_wire(@wire1)
    draw_wire(@wire2)
  end

  def draw_wire(wire)
    cx, cy = @ox, @oy

    wire.each do |cmd|
      distance = cmd[1..-1].to_i

      board[cy][cx] = '+' unless board[cy][cx] == 'O'

      case cmd[0]
      when 'R'
        left_right_wire(cy, cx + 1, distance)
        cx += distance
      when 'D'
        up_down_wire(cx, cy + 1, cy + distance)
        cy += distance
      when 'L'
        left_right_wire(cy, cx - distance, distance)
        cx -= distance
      else
        up_down_wire(cx, cy - distance, cy - 1)
        cy -= distance
      end
    end
  end

  def left_right_wire(y, start, dist)
    board[y].fill(start, dist) do |index|
      if board[y][index] == '.'
        '-'
      else
        @intersections << [index, y]
        'X'
      end
    end
  end

  def up_down_wire(x, start, finish)
    board[start..finish].each_with_index do |row, row_index|
      if row[x] == '.'
        row[x] = '|'
      else
        @intersections << [x, row_index]
        row[x] = 'X'
      end
    end
  end
end

wires_board = WiresBoard.new
puts "#{wires_board.intersections.map { |q| [q[0] - 20, q[1] - 20]}}"
puts wires_board.closest_intersectin
