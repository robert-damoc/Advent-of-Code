class Board
  BOARD_SIZE = 300
  SERIAL_NUMBER = 7803

  attr_reader :state

  def initialize
    @state = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }

    init_state
  end

  def solve_2
    result = solve(square_size: 1)
    output = result.merge({ square_size: 1 })
    p output
    2.upto(300) do |square_size|
      result = solve(square_size: square_size)
      puts result.merge({ square_size: square_size })
      if result[:total_power] > output[:total_power]
        output = result.merge({ square_size: square_size })
      end
    end
    output
  end

  def solve(square_size: 3)
    max_sum, max_x, max_y = -100, -1, -1
    (0...BOARD_SIZE - (square_size - 1)).each do |y|
      (0...BOARD_SIZE - (square_size - 1)).each do |x|
        sum = 0
        (0...square_size).each do |i|
          (0...square_size).each do |j|
            sum += @state[x + i][y + j]
          end
        end
        if sum > max_sum
          max_sum = sum
          max_x = x
          max_y = y
        end
      end
    end
    { total_power: max_sum, x: max_x, y: max_y }
  end

  private

  def init_state
    (0...BOARD_SIZE).each do |y|
      (0...BOARD_SIZE).each do |x|
        @state[x][y] = (((x + 10) * y + SERIAL_NUMBER) * (x + 10)) / 100 % 10 - 5
      end
    end
  end
end

board = Board.new
# p board.solve
p board.solve_2
