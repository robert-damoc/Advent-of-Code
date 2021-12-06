require 'basic_file_reader'

class Bingo
  attr_reader :boards, :draw_order, :score

  def initialize
    input = BasicFileReader.lines(file_name: 'input')

    @draw_order = input.shift.split(',').map(&:to_i)
    input.shift

    generate_boards(input)

    @score = 0
  end

  def play
    step until game_won?

    @score = boards[@won_index].flatten.compact.reduce(&:+) * @drawn_number
  end

  def play_to_the_end
    until boards.empty?
      play
      boards.delete_at(@won_index)
    end
  end

  private

  def game_won?
    boards.each_with_index do |board, index|
      @won_index = index

      return true if board.any? { |row| row.all?(&:nil?) }

      5.times do |col|
        return true if board.map { |row| row[col] }.all?(&:nil?)
      end
    end

    false
  end

  def step
    @drawn_number = draw_order.shift

    boards.each do |board|
      board.each do |row|
        row.map! { |el| el == @drawn_number ? nil : el }
      end
    end
  end

  def generate_boards(input)
    @boards = []

    until input.empty?
      board = []

      5.times do
        board << input.shift.split(' ').map(&:to_i)
      end

      input.shift
      @boards << board
    end
  end
end

bingo = Bingo.new
bingo.play
p bingo.score

bingo.play_to_the_end
p bingo.score
