require 'basic_file_reader'

# Class responsible for managing a single bag
class Bag
  EMPTY_LIST_STRING = 'no other bags'.freeze

  attr_reader :name, :parents, :children, :inner_list

  def initialize(name, inner_list)
    @name = name
    @inner_list = inner_list
    @parents = []
    @children = []
  end

  def mark
    @marked = true
  end

  def marked?
    @marked
  end
end

# Class responsible for managing the entire bags collection
class BagsFactory
  INNER_BAG_REG_EXP = /^(\d+) ([a-zA-Z ]+) bags?$/.freeze

  attr_reader :bags

  def initialize
    @bags = {}

    initialize_from_file
    add_relatives
  end

  def parents_count(starting_bag)
    count = 0
    queue = []
    current_bag = bags[starting_bag]
    current_bag.mark

    loop do
      queue += current_bag.parents.reject(&:marked?).each(&:mark)

      break if queue.empty?

      count += 1
      current_bag = queue.shift
    end

    count
  end

  def total_bags_inside(starting_bag)
    count = 0

    queue = []
    current_bag = bags[starting_bag]

    loop do
      queue += current_bag.children

      break if queue.empty?

      count += current_bag.children.size
      current_bag = queue.shift
    end

    count
  end

  private

  def initialize_from_file
    BasicFileReader.lines(file_name: 'input').each do |line|
      bag_name, inner_list = line[0..-2].split(' bags contain ')

      bags[bag_name] = Bag.new(bag_name, inner_list.split(', '))
    end
  end

  def add_relatives
    bags.each do |bag_name, bag|
      next if bag.inner_list[0] == Bag::EMPTY_LIST_STRING

      bag.inner_list.each do |inner_bag|
        count, inner_bag_name = inner_bag.scan(INNER_BAG_REG_EXP).flatten
        count.to_i.times { bags[bag_name].children << bags[inner_bag_name] }
        bags[inner_bag_name].parents << bags[bag_name]
      end
    end
  end
end

bags_factory = BagsFactory.new
p bags_factory.parents_count('shiny gold')
p bags_factory.total_bags_inside('shiny gold')
