# frozen_string_literal: true

class Game
  def initialize(input)
    @numbers = Hash.new { |h, k| h[k] = [] }

    input.each_with_index do |nr, index|
      @numbers[nr] << index
    end

    @last_number = input.last
    @last_index = input.size - 1
  end

  def play(iterations_count: 2_020)
    while @last_index < iterations_count - 1
      @last_index += 1

      step
    end

    @last_number
  end

  private

  def step
    if @numbers[@last_number].size > 1
      index_diff = (@numbers[@last_number][-1] - @numbers[@last_number][-2])
      add_index_for(index_diff)
    else
      add_index_for(0)
    end
  end

  def add_index_for(number)
    @last_number = number
    @numbers[number] << @last_index
  end
end

input_array = '0,6,1,7,2,19,20'.split(',').map(&:to_i)
game = Game.new(input_array)

p game.play(iterations_count: 2_020)
p game.play(iterations_count: 30_000_000)
