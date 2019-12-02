require 'basic_file_reader'

def compute_fuel(mass)
  fuel = mass / 3 - 2
  fuel < 0 ? 0 : fuel
end

# Task 1
fuel = BasicFileReader.lines(file_name: './inputs/day1')
                      .map { |nr| compute_fuel(nr.to_i) }
                      .reduce(:+)

puts fuel # 3147032

# Task 2
fuel = BasicFileReader.lines(file_name: './inputs/day1') do |nr|
  fuel = compute_fuel(nr.to_i)
  total_fuel = fuel

  while fuel > 0
    fuel = compute_fuel(fuel)
    total_fuel += fuel
  end

  total_fuel
end.reduce(:+)

puts fuel # 4717699
