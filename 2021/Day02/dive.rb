require 'basic_file_reader'

class Submarine
  class Command
    attr_accessor :direction, :ammount

    def initialize(line)
      @direction, @ammount = line.split(' ')

      @ammount = @ammount.to_i
      @ammount *= -1 if @direction == 'up'
    end
  end

  def initialize
    @x = 0
    @y = 0
    @aim = 0

    @commands = BasicFileReader.lines(file_name: 'input') { |line| Command.new(line) }
  end

  def dive!
    @commands.each do |cmd|
      case cmd.direction
      when 'forward'
        @x += cmd.ammount
      else
        @y += cmd.ammount
      end
    end

    @x * @y
  end

  def dive_with_aim!
    @commands.each do |cmd|
      case cmd.direction
      when 'forward'
        @x += cmd.ammount
        @y += @aim * cmd.ammount
      else
        @aim += cmd.ammount
      end
    end

    @x * @y
  end
end

p Submarine.new.dive!
p Submarine.new.dive_with_aim!
