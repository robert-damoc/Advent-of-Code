require 'basic_file_reader'

input = BasicFileReader.lines(file_name: 'input').map(&:to_i)

def depth_increases_count(input, window_size: 1)
  sum = 0

  input[window_size..-1].each_with_index do |el, index|
    sum += 1 if el > input[index]
  end

  sum
end

p depth_increases_count(input)
p depth_increases_count(input, window_size: 3)
