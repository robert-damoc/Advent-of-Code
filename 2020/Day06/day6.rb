require 'basic_file_reader'
require 'ostruct'

class Group
  def self.groups_factory
    [].tap do |groups|
      persons = []

      BasicFileReader.lines(file_name: 'input').each do |line|
        if line.empty?
          groups << Group.new(persons)
          persons = []
        else
          persons << OpenStruct.new(answers: line.split(''))
        end
      end

      groups << Group.new(persons)
    end
  end

  attr_reader :persons

  def initialize(persons)
    @persons = persons
  end

  def yes_answers
    @persons.flat_map(&:answers).uniq.count
  end

  def all_yes_answers
    @persons.map(&:answers).reduce(:&).count
  end
end

groups = Group.groups_factory

# Part 1
p groups.map(&:yes_answers).reduce(:+)

# Part 2
p groups.map(&:all_yes_answers).reduce(:+)
