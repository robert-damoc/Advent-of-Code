def get_file_input
  lines = []

  file = open 'input_day2'
  file.each { |line| lines << line.gsub("\n", '') }
  file.close

  lines
end

def first_quiz
  count_2, count_3 = 0, 0
  get_file_input.each() do |line|
    hz = line.split('').each_with_object(Hash.new(0)) { |ch, hz| hz[ch] += 1 }
    count_2 += 1 if hz.any? { |_, v| v == 2 }
    count_3 += 1 if hz.any? { |_, v| v == 3 }
  end
  count_2 * count_3
end

def hamming_distance_index(a, b)
  diff, the_i = 0, -1

  b_char = b.split('')
  a.each_char.with_index(0) do |a_ch, i|
    unless (a_ch == b_char[i])
      diff += 1
      the_i = i
    end

    return nil if diff > 1
  end

  return nil unless diff == 1

  the_i
end

def hamming_distance(s1, s2)
  s1.each_codepoint.zip(s2.each_codepoint).select { |l, r| l != r }.length
end

def second_quiz
  lines = get_file_input
  (0...lines.size).each do |i|
    (0...lines.size).each do |j|
      next if i == j

      index = hamming_distance_index(lines[i], lines[j])
      return lines[i].tap { |s| s.slice!(index) } if index
    end
  end
end

puts "result  first_quiz: #{first_quiz}"
# puts "result second_quiz: #{second_quiz}"
