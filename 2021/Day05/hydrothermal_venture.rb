require 'basic_file_reader'

Line = Struct.new(:x1, :y1, :x2, :y2) do
  def x_modifier
    @x_modifier ||= if x1 < x2
                      1
                    elsif x1 > x2
                      -1
                    else
                      0
                    end
  end

  def y_modifier
    @y_modifier ||= if y1 < y2
                      1
                    elsif y1 > y2
                      -1
                    else
                      0
                    end
  end

  def points_count
    @points_count ||= [(x1 - x2).abs, (y1 - y2).abs].max + 1
  end
end

class HydrothermalMap
  attr_reader :lines, :overlaps

  def initialize
    @lines = []

    BasicFileReader.lines(file_name: 'input') do |line|
      lines << Line.new(*line.split(/\D+/).map(&:to_i))
    end
  end

  def all_overlaps
    @overlaps = Hash.new(0)

    lines.each { |line| add_line_points(line) }

    overlaps.values.select { |v| v > 1 }.size
  end

  def vertical_and_horizontal_overlaps
    @overlaps = Hash.new(0)

    lines.each do |line|
      next if line.x1 != line.x2 && line.y1 != line.y2

      add_line_points(line)
    end

    overlaps.values.select { |v| v > 1 }.size
  end

  private

  def add_line_points(line)
    x = line.x1
    y = line.y1

    line.points_count.times do
      overlaps["#{x}-#{y}"] += 1

      x += line.x_modifier
      y += line.y_modifier
    end
  end

  def display_intersections
    0.upto(9) do |y|
      0.upto(9) do |x|
        print overlaps["#{x}-#{y}"].zero? ? '.' : overlaps["#{x}-#{y}"]
      end
      puts
    end
  end
end

hm = HydrothermalMap.new
p hm.vertical_and_horizontal_overlaps
p hm.all_overlaps
