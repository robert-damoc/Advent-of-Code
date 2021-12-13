require 'basic_file_reader'

class Octopus
  attr_reader :flashed, :energy_level, :flashes_count

  def initialize(energy_level)
    @energy_level = energy_level
    @flashed = false
    @flashes_count = 0
  end

  def inc
    @energy_level += 1
  end

  def flash
    return unless can_flash?

    @flashes_count += 1
    @flashed = true
  end

  def can_flash?
    energy_level > 9 && !@flashed
  end

  def reset
    @energy_level = 0
    @flashed = false
  end
end

class DumboOctopus
  attr_reader :matrix

  def initialize
    @matrix = []
    @completed_iterations = 0

    BasicFileReader.lines(file_name: 'input') do |line|
      matrix << line.split('').map { |energy_level| Octopus.new(energy_level.to_i) }
    end
  end

  def play(steps_count: 100)
    @completed_iterations = steps_count
    steps_count.times { step }
  end

  def find_sync_step
    return @sync_step if @sync_step

    (@completed_iterations + 1).step do |step_index|
      step(step_index)

      return @sync_step if @sync_step
    end
  end

  def step(step_index = 1)
    matrix.flatten.map(&:inc)
    flash
    matrix.flatten.select(&:flashed).map(&:reset)

    @sync_step = step_index if matrix.flatten.map(&:energy_level).all?(&:zero?)
  end

  def flashes_count
    matrix.flatten.map(&:flashes_count).reduce(:+)
  end

  private

  def flash
    loop do
      no_flashes = true

      matrix.each_with_index do |line, line_index|
        line.each_with_index do |octopus, col_index|
          next unless octopus.can_flash?

          increase_adjacent(line_index, col_index)
          no_flashes = false
        end
      end

      break if no_flashes
    end
  end

  def increase_adjacent(line_index, col_index)
    matrix[line_index][col_index].flash

    if line_index - 1 >= 0
      matrix[line_index - 1][col_index - 1].inc if col_index - 1 >= 0
      matrix[line_index - 1][col_index + 1].inc if col_index + 1 < matrix[line_index].size
      matrix[line_index - 1][col_index].inc
    end

    if line_index + 1 < matrix.size
      matrix[line_index + 1][col_index - 1].inc if col_index - 1 >= 0
      matrix[line_index + 1][col_index + 1].inc if col_index + 1 < matrix[line_index].size
      matrix[line_index + 1][col_index].inc
    end

    matrix[line_index][col_index - 1].inc if col_index - 1 >= 0
    matrix[line_index][col_index + 1].inc if col_index + 1 < matrix[line_index].size
  end
end

dumbo = DumboOctopus.new
dumbo.play
p dumbo.flashes_count
p dumbo.find_sync_step
