require 'basic_file_reader'

class Segment
  attr_accessor :x1, :y1, :x2, :y2, :a, :b, :c

  def initialize(x1, y1, x2, y2)
    @x1, @y1, @x2, @y2 = x1, y1, x2, y2
    @a = y2 - y1
    @b = x1 - x2
    @c = x2 * y1 - x1 * y2
  end

  def vertical?
    x1 == x2
  end

  def horizontal?
    y1 == y2
  end
end

class WiresBoard
  attr_accessor :wires, :segments, :intersections

  def initialize(wires_count)
    @wires = Array.new(wires_count) { [[0, 0]] }
    @segments = Array.new(wires_count) { [] }
    @intersections = []

    parse_points
    parse_segments
  end

  def test
    @wires.each_with_index do |wire, i|
      puts "Wire #{i}: #{wire}"
    end

    @segments.each_with_index do |segment, i|
      puts "Segment for wire #{i}: #{segment}"
    end
  end

  def closest_intersection
    find_intersections

    min_dist = Float::INFINITY

    @intersections.each do |x, y|
      dist = x.abs + y.abs
      min_dist = dist if min_dist > dist
    end

    min_dist
  end

  private

  def find_intersections
    segments1 = @segments[0]
    segments2 = @segments[1]

    segments1.each do |seg1|
      segments2.each do |seg2|
        next unless unique_possible_intersection?(seg1, seg2)

        if seg1.vertical?
          int_x = seg1.x1
          int_y = seg2.y1

          if (seg1.y1 >= int_y && seg1.y2 <= int_y ||
            seg1.y1 <= int_y && seg1.y2 >= int_y) &&
            (seg2.x1 >= int_x && seg2.x2 <= int_x ||
            seg2.x1 <= int_x && seg2.x2 >= int_x)
            @intersections << [int_x, int_y]
          end
        else
          int_x = seg2.x1
          int_y = seg1.y1

          if (seg1.x1 >= int_x && seg1.x2 <= int_x ||
            seg1.x1 <= int_x && seg1.x2 >= int_x) &&
            (seg2.y1 >= int_y && seg2.y2 <= int_y ||
            seg2.y1 <= int_y && seg2.y2 >= int_y)
            @intersections << [int_x, int_y]
          end
        end
      end
    end

    @intersections.delete([0, 0])
  end

  def unique_possible_intersection?(seg1, seg2)
    seg1.vertical? && seg2.horizontal? ||
      seg1.horizontal? && seg2.vertical?
  end

  def parse_segments
    @wires.each_with_index do |wire, wire_index|
      wire[0...-1].each_with_index do |point, index|
        next_point = wire[index + 1]
        @segments[wire_index] << Segment.new(point[0], point[1], next_point[0], next_point[1])
      end
    end
  end

  def parse_points
    # t1 = ['R8,U5,L5,D3', 'U7,R6,D4,L4']
    # t2 = ['R75,D30,R83,U83,L12,D49,R71,U7,L72', 'U62,R66,U55,R34,D71,R55,D58,R83']
    # t3 = ['R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51', 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7']
    # t3.each_with_index do |line, index|
    BasicFileReader.lines(file_name: './inputs/day3').each_with_index do |line, index|
      line.split(',').each do |cmd|
        last_point = @wires[index].last
        @wires[index] << nextCoords(last_point[0], last_point[1], cmd)
      end
    end
  end

  def nextCoords(first_x, first_y, cmd)
    modifier = cmd[1..-1].to_i

    case cmd[0]
    when 'R'
      [first_x + modifier, first_y]
    when 'L'
      [first_x - modifier, first_y]
    when 'D'
      [first_x, first_y + modifier]
    else
      [first_x, first_y - modifier]
    end
  end
end

wb = WiresBoard.new(2)
p wb.closest_intersection
