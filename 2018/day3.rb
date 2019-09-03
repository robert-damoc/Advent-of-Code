class Claim
  attr_reader :id, :left_padding, :top_padding, :width, :height

  def initialize(line)
    @id, rest = line.split(' @ ')

    padding, size = rest.split(': ')

    @left_padding, @top_padding = padding.split(',').map(&:to_i)
    @width, @height = size.split('x').map(&:to_i)
  end

  def coordinates
    [].tap do |coords|
      (@left_padding...(@left_padding + @width)).each do |x|
        (@top_padding...(@top_padding + @height)).each do |y|
          coords << [x, y]
        end
      end
    end
  end
end

class Board
  attr_reader :board, :board_size, :overlaps, :claims

  def initialize(claims)
    @claims = claims

    compute_board_size

    @board = Array.new(@board_size) { Array.new(@board_size) { '.' } }
  end

  def compute_overlaps(draw: false)
    @claims.each_with_index do |claim, index|
      claim.coordinates.each do |coord|
        if @board[coord[1]][coord[0]] != '.'
          @board[coord[1]][coord[0]] = 'X'
        else
          @board[coord[1]][coord[0]] = claim.id[1..-1]
        end
      end
    end

    draw_board if draw

    @overlaps = board_count_of('X')
  end

  def not_overlapping_id
    [].tap do |ids|
      @claims.each do |claim|
        expected_result = claim.width * claim.height
        actual_result = board_count_of(claim.id[1..-1])
        ids << claim.id if expected_result == actual_result
      end
    end
  end

  private

  def board_count_of(symbol)
    @board.map { |rows| rows.count(symbol) }.reduce(&:+)
  end


  def draw_board
    (0...@board_size).each do |i|
      (0...@board_size).each do |j|
        print @board[i][j]
      end
      puts
    end
  end

  def compute_board_size
    attributes = @claims.map { |c| { l: c.left_padding, t: c.top_padding, w: c.width, h: c.height } }
    board_w = attributes.map { |c| c[:l] }.max + attributes.map { |c| c[:w] }.max
    board_h = attributes.map { |c| c[:t] }.max + attributes.map { |c| c[:h] }.max
    @board_size = [board_h, board_w].max
  end
end

def get_file_input
  claims = []

  file = open 'input_day3'
  file.each do |line|
    claims << Claim.new(line.gsub("\n", ''))
  end
  file.close

  claims
end

def first_quiz
  board = Board.new(get_file_input)
  board.compute_overlaps
  board.overlaps
end

# This one takes ages
def second_quiz
  board = Board.new(get_file_input)
  board.compute_overlaps
  board.not_overlapping_id
end

puts "result  first_quiz: #{first_quiz}"
puts "result second_quiz: #{second_quiz}"
