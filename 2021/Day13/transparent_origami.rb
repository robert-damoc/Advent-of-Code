require 'basic_file_reader'

Point = Struct.new(:x, :y)
Fold = Struct.new(:axis, :coord)

class TransparentOrigami
  attr_reader :points, :folds

  def initialize
    @points = []
    @folds = []

    read_file
  end

  def fold_once
    fold_by(folds.first)
  end

  def fold_all
    folds.each do |fold|
      fold_by(fold)
    end
  end

  def to_s
    find_bounds

    @min_y.upto(@max_y) do |y|
      @min_x.upto(@max_x) do |x|
        print points.find { |point| point.x == x && point.y == y } ? '#' : '.'
      end
      puts
    end
  end

  def unique_points
    points.uniq { |point| [point.x, point.y] }.size
  end

  private

  def find_bounds
    @min_y, @max_y = points.sort { |p1, p2| p1.y <=> p2.y }.map(&:y).minmax
    @min_x, @max_x = points.sort { |p1, p2| p1.x <=> p2.x }.map(&:x).minmax
  end

  def fold_by(fold)
    points.each do |point|
      value = point.send(fold.axis)
      next unless value > fold.coord

      new_value = fold.coord - (value - fold.coord)

      point.send("#{fold.axis}=", new_value)
    end
  end

  def read_file
    read_instructions = false
    BasicFileReader.lines(file_name: 'input') do |line|
      if line.empty?
        read_instructions = true
      else
        read_instructions ? add_fold(line) : add_point(line)
      end
    end
  end

  def add_fold(line)
    axis, coord = line.split(' ').last.split('=')
    folds << Fold.new(axis, coord.to_i)
  end

  def add_point(line)
    points << Point.new(*line.split(',').map(&:to_i))
  end
end

transparent_origami = TransparentOrigami.new
transparent_origami.fold_once
puts transparent_origami.unique_points
transparent_origami.fold_all
puts transparent_origami
