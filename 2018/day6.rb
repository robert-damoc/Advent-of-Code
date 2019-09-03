class Point
  @@label = 0

  attr_reader :x, :y, :label
  attr_accessor :area

  def initialize(x, y)
    @x = x
    @y = y
    @label = (@@label + 65).chr

    @area = 1

    @@label += 1
  end
end

class Board
  attr_reader :points, :board_size, :in_region_count, :region_distance

  def initialize(region_distance: 0)
    @region_distance = region_distance
    @in_region_count = 0
    @points = []

    file = open 'input_day6'
    file.each do |line|
      @points << Point.new(*line.gsub("\n", '').split(', ').map(&:to_i))
    end
    file.close

    @board_size = [@points.map(&:x).max, @points.map(&:y).max].max + 1
  end

  def draw
    (0...@board_size).each do |i|
      (0...@board_size).each do |j|
        point = nil
        if @points.any? { |po| point = po; po.x == j && po.y == i }
          print point.label
        else
          print '.'
        end
      end
      puts
    end
  end

  def solve(scale)
    (-scale...@board_size + scale).each do |i|
      (-scale...@board_size + scale).each do |j|
        point = nil
        if @points.any? { |po| point = po; po.x == j && po.y == i }
        else
          distances = @points.map do |po|
            [po.label, manhattan_distance(j, i, po.x, po.y)]
          end

          smaller_distances = distances.select { |dist| dist[1] == distances.min { |a, b| a[1] <=> b[1] }[1] }

          if smaller_distances.count == 1
            selected_point = @points.select { |po| po.label == smaller_distances[0][0] }[0]
            selected_point.area += 1
          else
          end
        end
      end
    end
  end

  def solve_2
    (0...@board_size).each do |y|
      (0...@board_size).each do |x|
        distances = @points.map { |po| manhattan_distance(x, y, po.x, po.y) }
        @in_region_count += 1 if distances.reduce(&:+) < @region_distance
      end
    end
  end

  private

  def manhattan_distance(x1, y1, x2, y2)
    (x1 - x2).abs + (y1 - y2).abs
  end
end

def first_quiz
  board = Board.new
  board.solve(0)
  a = board.points.map(&:area)
  board.solve(20)
  b = board.points.map(&:area)
  (a & b).sort.reverse[0]
end

def second_quiz
  board = Board.new(region_distance: 10_000)
  board.solve_2
  board.in_region_count
end

# puts "result  first_quiz: #{first_quiz}"
puts "result second_quiz: #{second_quiz}"
