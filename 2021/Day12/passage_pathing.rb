require 'basic_file_reader'

class PassagePathing
  attr_reader :caves_connections, :valid_paths

  START_CAVE = 'start'.freeze
  END_CAVE = 'end'.freeze

  def initialize
    @caves_connections = Hash.new { |h, k| h[k] = [] }

    BasicFileReader.lines(file_name: 'input') do |line|
      a, b = line.split('-')
      caves_connections[a] << b
      caves_connections[b] << a
    end
  end

  def paths(allow_small_twice: false)
    @valid_paths = []

    find_paths(START_CAVE, allow_small_twice: allow_small_twice)

    @valid_paths
  end

  private

  def find_paths(current_cave, path = '', allow_small_twice: false)
    path += "#{current_cave},"

    if current_cave == END_CAVE
      @valid_paths << path[0...-1]
      return
    end

    caves_connections[current_cave].each do |cave|
      if big_cave?(cave) || !path.include?(cave)
        find_paths(cave, path, allow_small_twice: allow_small_twice)
      elsif allow_small_twice && !margin?(cave)
        find_paths(cave, path, allow_small_twice: false)
      end
    end
  end

  def margin?(cave)
    [START_CAVE, END_CAVE].include?(cave)
  end

  def small_cave?(cave)
    !big_cave?(cave)
  end

  def big_cave?(cave)
    cave == cave.upcase
  end
end

pp = PassagePathing.new
p pp.paths.size
p pp.paths(allow_small_twice: true).size
