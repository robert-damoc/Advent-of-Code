$debug = false

class Cart
  attr_reader :int_dir, :int_dir_index
  attr_accessor :row, :col, :direction

  attr_reader :move_left, :move_right

  def initialize(row, col, direction)
    @row, @col = row, col
    @direction = direction
    @int_dir_index = -1
    @int_dir = [:left, :straight, :right]
    @move_left = { left: :down, down: :right, right: :up, up: :left }
    @move_right = { left: :up, up: :right, right: :down, down: :left }
    @move_bslash = { left: :up, right: :down, up: :left, down: :right }
    @move_slash = { left: :down, right: :up, up: :right, down: :left }
  end

  def label
    case @direction
    when :left
      '<'
    when :right
      '>'
    when :up
      '^'
    else
      'v'
    end
  end

  def update_label(location)
    if location == '+'
      @int_dir_index = (@int_dir_index + 1) % 3
      if @int_dir[@int_dir_index] == :left
        @direction = @move_left[@direction]
      elsif @int_dir[@int_dir_index] == :right
        @direction = @move_right[@direction]
      end
    elsif location == '\\'
      @direction = @move_bslash[@direction]
    elsif location == '/'
      @direction = @move_slash[@direction]
    end
  end

  def move
    case @direction
    when :left
      @col -= 1
    when :right
      @col += 1
    when :up
      @row -= 1
    else # :down
      @row += 1
    end
  end
end

class Board
  attr_reader :carts, :matrix, :crash, :last_cart_standing

  def initialize
    @carts = []
    @crash = nil
    @last_cart_standing = nil
    init_matrix
  end

  def first_crash
    draw
    until @crash
      step
      draw
    end
    @crash
  end

  def last_standing
    draw_skip_crash
    until @last_cart_standing
      step
      draw_skip_crash
    end
    @last_cart_standing
  end

  private

  def step
    @carts.sort { |p1, p2| p1.col <=> p2.col }.sort { |p1, p2| p1.row <=> p2.row }
    @carts.each do |cart|
      cart.move
      cart.update_label(@matrix[cart.row][cart.col])
    end
  end

  def draw_skip_crash
    @matrix.each_with_index do |line, row|
      line.each_with_index do |location, col|
        selected_carts = @carts.select { |cart| cart.row == row && cart.col == col }
        if selected_carts.empty?
          print location if $debug
        elsif selected_carts.size == 1
          print selected_carts.first.label if $debug
        else
          @carts.reject! { |cart| cart.row == row && cart.col == col }
          print 'X' if $debug
        end
        if @carts.size == 1 && @last_cart_standing.nil?
          @last_cart_standing = [@carts.first.col, @carts.first.row]
        end
      end
      puts if $debug
    end
    puts if $debug
    if @last_cart_standing
      $debug = true
      draw
    end
  end

  def draw
    @matrix.each_with_index do |line, row|
      line.each_with_index do |location, col|
        selected_carts = @carts.select { |cart| cart.row == row && cart.col == col }
        if selected_carts.empty?
          print location if $debug
        elsif selected_carts.size == 1
          print selected_carts.first.label if $debug
        else
          @crash = [col, row] unless @crash
          print 'X' if $debug
        end
      end
      puts if $debug
    end
    puts if $debug
  end

  def init_matrix
    content = File.read('input_day13').split("\n")
    rows_count = content.size
    cols_count = content.map(&:size).max

    @matrix = Array.new(rows_count) { Array.new(cols_count) { ' ' } }

    row = 0
    content.each do |line|
      line.each_char.with_index(0) do |ch, col|
        case ch
        when '<'
          @carts << Cart.new(row, col, :left)
          @matrix[row][col] = '-'
        when '>'
          @carts << Cart.new(row, col, :right)
          @matrix[row][col] = '-'
        when '^'
          @carts << Cart.new(row, col, :up)
          @matrix[row][col] = '|'
        when 'v'
          @carts << Cart.new(row, col, :down)
          @matrix[row][col] = '|'
        else
          @matrix[row][col] = ch
        end
      end
      row += 1
    end
  end
end

board = Board.new
p board.last_standing

# 110,21
# 111,21
# 110,20
# 110,22
