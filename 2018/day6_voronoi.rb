class Biome
  attr_reader :point, :label

  def initialize(point, label)
    @point = point
    @label = label
  end
end

class Point
  @@label = 0

  attr_reader :x, :y, :label
  attr_accessor :area

  def initialize(x, y)
    @x = x
    @y = y
    @area = 0
  end

  def self.manhattan_distance(p1, p2)
    (p1.x - p2.x).abs + (p1.y - p2.y).abs
  end
end

class Board
  attr_reader :points, :biomes, :board_size

  def initialize
    @points = []
    @biomes = []

    file = open 'input_day6'
    file.each do |line|
      @points << Point.new(*line.gsub("\n", '').split(', ').map(&:to_i))
    end
    file.close

    label = 0
    @points.each do |point|
      @biomes << Biome.new(point, (label + 65).chr)
      label += 1
    end

    @board_size = [@points.map(&:x).max, @points.map(&:y).max].max + 1
  end

  def draw
    (0..@board_size).each do |y|
      (0..@board_size).each do |x|
        point = Point.new(x, y)
        label = find_closest_biome_label(point)
        print label
      end
      print "\n"
    end
  end

  private

  def find_closest_biome_label(point)
    distances = @biomes.map { |biome| [biome.label, Point.manhattan_distance(point, biome.point)] }

    smaller_distances = distances.select { |dist| dist[1] == distances.min { |a, b| a[1] <=> b[1] }[1] }
    if smaller_distances.count == 1
      smaller_distances[0][0]
    else
      '.'
    end
  end
end

def first_quiz
  board = Board.new
  board.draw
end

puts "result  first_quiz: #{first_quiz}"
