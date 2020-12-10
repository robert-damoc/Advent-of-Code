# frozen_string_literal: true

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

    return true
  end

  false
end

def find_invalid_number(numbers, base_index)
  i = base_index

  loop do
    break if i >= numbers.size

    presence_hash = hash_with_valid_elements(numbers[i - base_index...i], numbers[i])
    return numbers[i] unless sum_of_two(presence_hash, numbers[i])

    i += 1
  end
end

numbers = BasicFileReader.lines(file_name: 'input').map(&:to_i)

invalid_number = find_invalid_number(numbers, 25)

# Part 1
p invalid_number

# Part 2
def find_contiguous_set_indexes(numbers, sum)
  base_index = 0

  loop do
    current_sum = numbers[base_index] + numbers[base_index + 1]
    current_index = base_index + 2

    loop do
      break if current_sum >= sum

      current_sum += numbers[current_index]
      current_index += 1
    end

    base_index += 1 if current_sum > sum
    return [base_index, current_index - 1] if current_sum == sum
  end
end

def encryption_weakness(numbers, invalid_number)
  low, high = find_contiguous_set_indexes(numbers, invalid_number)
  contiguous_set = numbers[low..high]

  contiguous_set.min + contiguous_set.max
end

p encryption_weakness(numbers, invalid_number)
