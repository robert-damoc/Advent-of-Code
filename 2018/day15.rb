require 'basic_file_reader'

TILE_TYPES = {
  wall: '#'.freeze,
  open: '.'.freeze,
  goblin: 'G'.freeze,
  elf: 'E'.freeze
}.freeze

ENEMIES = {
  goblin: 'E',
  elf: 'G'
}.freeze

ENVIRONMENT = [TILE_TYPES[:wall], TILE_TYPES[:open]].freeze

WITH_HP = true

class Unit
  @@default_hp = 5
  @@default_dmg = 3

  attr_reader :type, :row, :col, :hp, :dmg

  def initialize(row:, col:, type:)
    @hp, @dmg = @@default_hp, @@default_dmg
    @row, @col = row, col
    @type = type
  end

  def to_s
    TILE_TYPES[type]
  end

  def get_hit(dmg:)
    @hp -= dmg
  end

  def dead?
    @hp <= 0
  end
end

class Game
  attr_reader :board, :elfs, :goblins

  def initialize
    @board = []
    @elfs, @goblins = [], []

    BasicFileReader.lines(file_name: 'input_day15') do |line|
      @board << line.split('')
    end

    init_units
  end

  def play
    1.step do |i|
      draw

      @board.each do |row|
        row.each do |tile|
          next if ENVIRONMENT.include?(tile)
          @unit = tile
          move
          attack
        end
      end

      if @elfs.empty? || @goblins.empty? || i > 3
        break
      end
    end
  end

  private

  def attack
    return unless enemy_in_range?
    enemy = near_tiles.find { |tile| tile.to_s == ENEMIES[@unit.type] }

    enemy.get_hit(dmg: @unit.dmg)

    if enemy.dead?
      @board[enemy.row][enemy.col] = TILE_TYPES[:open]
      if enemy.type == :goblin
        @goblins.delete(enemy)
      else
        @elfs.delete(enemy)
      end
    end
  end

  def move
    return if enemy_in_range?
    puts "FIND NEAREST UNIT"
  end

  def enemy_in_range?
    near_tiles.map(&:to_s).include? ENEMIES[@unit.type]
  end

  def near_tiles
    [
      @board[@unit.row - 1][@unit.col],
      @board[@unit.row][@unit.col - 1],
      @board[@unit.row][@unit.col + 1],
      @board[@unit.row + 1][@unit.col]
    ]
  end

  def draw
    @board.each do |row|
      row.each do |tile|
        if WITH_HP
          if ENVIRONMENT.include?(tile)
            print " #{tile} "
          elsif tile.hp < 10
            print " #{tile.hp} "
          elsif tile.hp < 100
            print " #{tile.hp}"
          else
            print tile.hp
          end
        else
          print tile
        end
      end
      puts
    end
  end

  def init_units
    @board.each_with_index do |row, row_i|
      row.each_with_index do |tile, col_i|
        if tile == TILE_TYPES[:goblin]
          @goblins << Unit.new(row: row_i, col: col_i, type: :goblin)
          @board[row_i][col_i] = @goblins.last
        elsif tile == TILE_TYPES[:elf]
          @elfs << Unit.new(row: row_i, col: col_i, type: :elf)
          @board[row_i][col_i] = @elfs.last
        end
      end
    end
  end
end

game = Game.new
game.play
