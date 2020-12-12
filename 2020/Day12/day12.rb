# frozen_string_literal: true

require 'basic_file_reader'

# This class only handles a basic ship
class Ship
  attr_accessor :x, :y, :direction
  def initialize
    @direction = %w[E S W N]
    @x = 0
    @y = 0
  end

  def sail
    BasicFileReader.lines(file_name: 'input') do |line|
      step(line[0], line[1..-1].to_i)
    end
  end

  def distance
    x.abs + y.abs
  end

  protected

  def step(action, value)
    case action
    when 'N', 'S', 'E', 'W' then move(action, value)
    when 'L', 'R' then rotate(action, value)
    when 'F' then move_forward(value)
    end
  end

  def move(action, value)
    case action
    when 'N' then @y += value
    when 'S' then @y -= value
    when 'E' then @x += value
    when 'W' then @x -= value
    end
  end

  def rotate(action, value)
    case action
    when 'L' then direction.rotate!(-value / 90)
    when 'R' then direction.rotate!(value / 90)
    end
  end

  def move_forward(value)
    case @direction.first
    when 'N' then @y += value
    when 'S' then @y -= value
    when 'E' then @x += value
    when 'W' then @x -= value
    end
  end
end

# This will handle the ship with waypoint
class ShipWithWaypoint < Ship
  attr_accessor :wp

  # Use this to handle the waypoint
  class Waypoint
    attr_accessor :x_offset, :y_offset

    def initialize(ship)
      @x_offset = ship.x + 10
      @y_offset = ship.y + 1
    end

    def rotate(value)
      case value
      when 1
        @x_offset, @y_offset = @y_offset, -@x_offset
      when 2
        @x_offset = -@x_offset
        @y_offset = -@y_offset
      when 3
        @x_offset, @y_offset = -@y_offset, @x_offset
      end
    end
  end

  def initialize
    super
    @wp = Waypoint.new(self)
  end

  private

  def move(action, value)
    case action
    when 'N' then wp.y_offset += value
    when 'S' then wp.y_offset -= value
    when 'E' then wp.x_offset += value
    when 'W' then wp.x_offset -= value
    end
  end

  def rotate(action, value)
    rotation_ammount = value / 90
    rotation_ammount = 4 - rotation_ammount if action == 'L'

    wp.rotate(rotation_ammount)
  end

  def move_forward(value)
    @x += value * wp.x_offset
    @y += value * wp.y_offset
  end
end

ship = Ship.new
ship.sail
p ship.distance

ship_whit_wp = ShipWithWaypoint.new
ship_whit_wp.sail
p ship_whit_wp.distance
