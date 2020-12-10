require 'basic_file_reader'

seat_places = BasicFileReader.lines(file_name: 'input').each do |line|
  line.gsub!(/[FBRL]/) { |ch| %w[F L].include?(ch) ? '0' : '1' }
end

# Part 1
p seat_places.max.to_i(2)

# Part 2
seat_places.map! { |seat_place| seat_place.to_i(2) }
complete_range = [*seat_places.min..seat_places.max]

p (complete_range - seat_places)[0]
