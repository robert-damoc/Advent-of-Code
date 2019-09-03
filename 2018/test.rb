require 'basic_file_reader'

BasicFileReader.lines(file_name: 'input_day6') do |line|
  print line.split(', ').map(&:to_i)
  puts
end


# what do your moned need to be considered a valid crypto curency
#   coint-market
