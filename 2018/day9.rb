require 'basic_file_reader'

class Node
  attr_reader :value
  attr_accessor :prev, :next

  def initialize(value:)
    @value = value
    @prev = @next = self
  end
end

class MarbleGame
  attr_reader :current_marble, :players, :players_count, :marbles_count

  def initialize
    BasicFileReader.content(file_name: 'input_day9') do |content|
      regex = /(.+) players; last marble is worth (.+) points/
      @players_count, @marbles_count = content.scan(regex).flatten.map(&:to_i)
    end

    @players = Array.new(players_count) { 0 }
    @current_marble = Node.new(value: 0)
  end

  def play(marbles_count_factor: 1)
    1.upto(marbles_count * marbles_count_factor) do |i|
      (i % 23).zero? ? add_points(i) : insert_marbel(i)
    end

    players.max
  end

  private

  def insert_marbel(i)
    new_marble = Node.new(value: i)

    new_marble.next = @current_marble.next.next
    new_marble.next.prev = new_marble
    @current_marble.next.next = new_marble
    new_marble.prev = @current_marble.next

    @current_marble = new_marble
  end

  def add_points(i)
    marble_to_remove = @current_marble.prev.prev.prev.prev.prev.prev.prev
    @players[(i - 1) % players_count] += marble_to_remove.value + i

    marble_to_remove.prev.next = marble_to_remove.next
    marble_to_remove.next.prev = marble_to_remove.prev
    @current_marble = marble_to_remove.next
  end
end

# First Quiz
game = MarbleGame.new
p game.play

# Second Quiz
game = MarbleGame.new
p game.play(marbles_count_factor: 100)
