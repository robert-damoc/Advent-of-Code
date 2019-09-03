def get_file_input
  file = open 'input_day1'
  content = file.read
  file.close

  content.split(',').map(&:to_i)
end

def first_quiz
  get_file_input.reduce(&:+)
end

def second_quiz
  numbers = get_file_input
  hz = Hash.new(0)
  score = 0
  hz[score] = 1

  loop do
    numbers.each do |i|
      score += i
      return score unless hz[score].zero?
      hz[score] += 1
    end
  end
end

puts "result  first_quiz: #{first_quiz}"
puts "result second_quiz: #{second_quiz}"
