def get_file_input
  file = open 'input_day5'
  file.first.gsub("\n", '').tap do
    file.close
  end
end

def reduced_polymer_length(input)
  input = input.split('').map(&:ord)
  letters_diff = 32
  loop do
    index = nil
    (0...input.size - 2).each do |i|
      if (input[i] - input[i + 1]).abs == 32
        index = i
        break
      end
    end
    if index
      input.delete_at(index)
      input.delete_at(index)
    else
      break
    end
  end

  input.map(&:chr).join.length
end

def first_quiz
  reduced_polymer_length(get_file_input)
end

def second_quiz
  input = get_file_input
  lengths = []
  (0...26).map { |q| (q + 65).chr }.each  do |upper_letter|
    lower_letter = (upper_letter.ord + 32).chr
    lengths << reduced_polymer_length(input.gsub(/[#{upper_letter}#{lower_letter}]/, ''))
  end
  lengths.min
end

puts "result  first_quiz: #{first_quiz}"
puts "result second_quiz: #{second_quiz}"
