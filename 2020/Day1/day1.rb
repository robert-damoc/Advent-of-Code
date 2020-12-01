require 'basic_file_reader'

def hash_with_valid_elements(input, sum)
  input.each_with_object({}) do |element, acc|
    next if element > sum

    acc[element] = true
  end
end

def sum_of_two(presence_hash, sum)
  presence_hash.keys.each do |value|
    next unless presence_hash[sum - value]

    return (sum - value) * value
  end

  nil
end

def sum_of_three(presence_hash, sum)
  presence_hash.keys.each do |value|
    presence_hash.delete(value)

    partial_solution = sum_of_two(presence_hash, sum - value)
    return partial_solution * value if partial_solution
  end

  nil
end

sum = 2020
input = BasicFileReader.lines(file_name: 'input').map(&:to_i)
presence_hash = hash_with_valid_elements(input, sum)

p sum_of_two(presence_hash, sum)
p sum_of_three(presence_hash, sum)
