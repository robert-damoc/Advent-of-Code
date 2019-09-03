def first_quiz
  input = %w(14	0	15	12	11	11	3	5	1	6	8	4	9	1	8	4)
  input = input.map(&:to_i)
  output = 0

  max_block_index = input.index(input.max)

  seen_configurations = [input.join(',')]

  loop do
    output += 1

    current_index = (max_block_index + 1) % input.length
    blocks_to_redistribute = input[max_block_index]
    input[max_block_index] = 0

    while blocks_to_redistribute > 0
      input[current_index] += 1
      current_index = (current_index + 1) % input.length
      blocks_to_redistribute -= 1
    end

    break if seen_configurations.include?(input.join(','))

    max_block_index = input.index(input.max)

    seen_configurations << input.join(',')
  end

  output
end

def second_quiz
  input = %w(14	0	15	12	11	11	3	5	1	6	8	4	9	1	8	4)
  input = input.map(&:to_i)
  output = 0

  max_block_index = input.index(input.max)

  seen_configurations = [input.join(',')]

  loop do

    current_index = (max_block_index + 1) % input.length
    blocks_to_redistribute = input[max_block_index]
    input[max_block_index] = 0

    while blocks_to_redistribute > 0
      input[current_index] += 1
      current_index = (current_index + 1) % input.length
      blocks_to_redistribute -= 1
    end

    if seen_configurations.include?(input.join(','))
      output = seen_configurations.length - seen_configurations.index(input.join(','))
      break
    end

    max_block_index = input.index(input.max)

    seen_configurations << input.join(',')
  end

  output
end

p "first_quiz: #{first_quiz}"
p "second_quiz: #{second_quiz}"