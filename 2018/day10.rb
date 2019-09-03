require 'basic_file_reader'

class Point
  attr_reader :x, :y, :vx, :vy

  def initialize(x, y, vx, vy)
    @x, @y = x, y
    @vx, @vy = vx, vy
  end

  def pass_1_sec
    @x += @vx
    @y += @vy
  end
end

class Board
  attr_reader :points

  def initialize
    @points = BasicFileReader.lines(file_name: 'input_day10') do |line|
      Point.new(
        *(line.scan(/position=<(.*),(.*)> velocity=<(.*),(.*)>/).flatten.map(&:to_i))
      )
    end
  end

  def solve
    seconds = 0
    loop do
      @points.map(&:pass_1_sec)
      seconds += 1

      board_min_w, board_max_w = @points.map(&:x).minmax
      board_min_h, board_max_h = @points.map(&:y).minmax

      if (board_max_h - board_min_h) < 10
        board_min_h.upto(board_max_h) do |y|
          board_min_w.upto(board_max_w) do |x|
            if @points.any? { |po| po.y == y && po.x == x }
              print '#'
            else
              print '.'
            end
          end
          puts
        end
        break
      end
    end
    seconds
  end

  private

  def point_there?(x, y, second)
    @points.any? do |po|
      (po.x + (second * po.vx)) == x &&
      (po.y + (second * po.vy)) == y
    end
  end
end


board = Board.new;
p board.solve
