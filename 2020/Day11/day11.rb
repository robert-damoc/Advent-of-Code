# frozen_string_literal: true

require 'basic_file_reader'

# Encapsulates the game of life logic
class GameOfLife
  FLOOR = '.'
  EMPTY_SEAT = 'L'
  OCCUPIED_SEAT = '#'

  def initialize(max_iterations: 10_000)
    init_board_from_file
    @max_iterations = max_iterations
  end

  def play(mode:)
    current_iteration = 1
    loop do
      old_board = @board.dup
      do_step(mode)

      break if old_board == @board

      current_iteration += 1
      break if current_iteration > @max_iterations
    end
  end

  def occupied_seats
    @board.flatten.count { |seat| seat == OCCUPIED_SEAT }
  end

  private

  def do_step(mode)
    if mode == :easy
      step(occupied_to_empty_threshold: 4, occupied_sets_method: method(:occupied_neighbour_seats))
    else
      step(occupied_to_empty_threshold: 5, occupied_sets_method: method(:occupied_seats_in_vision))
    end
  end

  def step(occupied_to_empty_threshold:, occupied_sets_method:)
    next_step_board = Array.new(@board.size) { Array.new(@board[0].size, FLOOR) }

    @board.each_with_index do |line, line_index|
      line.each_with_index do |seat, col_index|
        occupied = occupied_sets_method.call(line_index, col_index)
        next_step_board[line_index][col_index] = seat_value(seat, occupied_to_empty_threshold, occupied)
      end
    end

    @board = next_step_board
  end

  def seat_value(seat, occupied_to_empty_threshold, occupied)
    if seat == FLOOR
      FLOOR
    elsif seat == EMPTY_SEAT && occupied.zero?
      OCCUPIED_SEAT
    elsif seat == OCCUPIED_SEAT && occupied >= occupied_to_empty_threshold
      EMPTY_SEAT
    else
      seat
    end
  end

  def occupied_seats_in_vision(line_index, col_index)
    occupied = 0

    offset = 1
    offset += 1 while type?(line_index - offset, col_index - offset, FLOOR)
    occupied += 1 if type?(line_index - offset, col_index - offset, OCCUPIED_SEAT)

    offset = 1
    offset += 1 while type?(line_index - offset, col_index, FLOOR)
    occupied += 1 if type?(line_index - offset, col_index, OCCUPIED_SEAT)

    offset = 1
    offset += 1 while type?(line_index - offset, col_index + offset, FLOOR)
    occupied += 1 if type?(line_index - offset, col_index + offset, OCCUPIED_SEAT)

    offset = 1
    offset += 1 while type?(line_index, col_index - offset, FLOOR)
    occupied += 1 if type?(line_index, col_index - offset, OCCUPIED_SEAT)

    offset = 1
    offset += 1 while type?(line_index, col_index + offset, FLOOR)
    occupied += 1 if type?(line_index, col_index + offset, OCCUPIED_SEAT)

    offset = 1
    offset += 1 while type?(line_index + offset, col_index - offset, FLOOR)
    occupied += 1 if type?(line_index + offset, col_index - offset, OCCUPIED_SEAT)

    offset = 1
    offset += 1 while type?(line_index + offset, col_index, FLOOR)
    occupied += 1 if type?(line_index + offset, col_index, OCCUPIED_SEAT)

    offset = 1
    offset += 1 while type?(line_index + offset, col_index + offset, FLOOR)
    occupied += 1 if type?(line_index + offset, col_index + offset, OCCUPIED_SEAT)

    occupied
  end

  def occupied_neighbour_seats(line_index, col_index)
    occupied = 0

    occupied += 1 if type?(line_index - 1, col_index - 1, OCCUPIED_SEAT)
    occupied += 1 if type?(line_index - 1, col_index, OCCUPIED_SEAT)
    occupied += 1 if type?(line_index - 1, col_index + 1, OCCUPIED_SEAT)

    occupied += 1 if type?(line_index, col_index - 1, OCCUPIED_SEAT)
    occupied += 1 if type?(line_index, col_index + 1, OCCUPIED_SEAT)

    occupied += 1 if type?(line_index + 1, col_index - 1, OCCUPIED_SEAT)
    occupied += 1 if type?(line_index + 1, col_index, OCCUPIED_SEAT)
    occupied += 1 if type?(line_index + 1, col_index + 1, OCCUPIED_SEAT)

    occupied
  end

  def type?(line_index, col_index, type)
    return if line_index.negative? || line_index >= @board.size
    return if col_index.negative? || col_index >= @board[0].size

    @board[line_index][col_index] == type
  end

  def init_board_from_file
    @board = BasicFileReader.lines(file_name: 'input').map { |line| line.split('') }
  end
end

gol = GameOfLife.new
gol.play(mode: :easy)
p gol.occupied_seats

gol = GameOfLife.new
gol.play(mode: :hard)
p gol.occupied_seats
