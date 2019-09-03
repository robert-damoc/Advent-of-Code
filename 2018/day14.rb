class CookBook
  @@recipes = 9
  @@size_after = 5
  @@to_find = '939601'
  @@to_find_size = @@to_find.size
  @@debug = false

  attr_reader :recipes, :e1_i, :e2_i, :found

  def initialize
    @recipes = [3, 7]
    @e1_i = 0
    @e2_i = 1
  end

  def solve
    draw if @@debug
    while @recipes.size < (@@recipes + @@size_after)
      step
    end
    @recipes[@@recipes...@@recipes + @@size_after].join
  end

  def solve_2
    @found = false
    draw if @@debug
    until @found
      step_2
    end
    @recipes[0...-@@to_find_size].size
  end

  private

  def step_2
    new_recipes = @recipes[@e1_i] + @recipes[@e2_i]
    if new_recipes < 10
      @recipes << new_recipes
    else
      @recipes << new_recipes / 10 << new_recipes % 10
    end
    is_found?

    inc_ex_i
    draw if @@debug
  end

  def is_found?
    if @recipes.size < @@to_find_size
      @found = false
    else
      @found = @recipes[-@@to_find_size..-1].join == @@to_find
      if @recipes.size > @@to_find_size
        @found ||= @recipes[-(@@to_find_size + 1)..-2].join == @@to_find
      end
    end
  end

  def step
    new_recipes = @recipes[@e1_i] + @recipes[@e2_i]
    if new_recipes < 10
      @recipes << new_recipes
    else
      @recipes << new_recipes / 10 << new_recipes % 10
    end

    inc_ex_i
    draw if @@debug
  end

  def inc_ex_i
    @e1_i = (1 + @e1_i + @recipes[@e1_i]) % @recipes.size
    @e2_i = (1 + @e2_i + @recipes[@e2_i]) % @recipes.size
  end

  def draw
    recipes.each_with_index do |recipe, i|
      el = ''
      if e1_i == i
        el = "(#{recipe})"
      elsif e2_i == i
        el = "[#{recipe}]"
      else
        el = " #{recipe} "
      end

      print el
    end
    puts
  end
end

cb = CookBook.new

p cb.solve_2
