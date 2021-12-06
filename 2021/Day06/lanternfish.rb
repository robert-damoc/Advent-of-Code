require 'basic_file_reader'

class LanternfishSchool
  attr_reader :initial_population, :population

  def initialize
    @initial_population = BasicFileReader.content(file_name: 'input').split(',').map(&:to_i)
  end

  def simulate(days: 80)
    @population = Hash.new(0).merge(@initial_population.tally)

    days.times { tick }
  end

  def size
    population.values.reduce(&:+)
  end

  private

  def tick
    new_fish_count = population[0]

    0.upto(7) do |index|
      population[index] = population[index + 1]
    end

    population[6] += new_fish_count
    population[8] = new_fish_count
  end
end

school = LanternfishSchool.new
school.simulate
p school.size

school.simulate(days: 256)
p school.size
