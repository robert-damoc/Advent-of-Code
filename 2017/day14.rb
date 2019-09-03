def knot_hash(input)
  list = [*0...256]
  skip_size, current_position = 0, 0

  input = input.split('').map(&:ord) + [17, 31, 73, 47, 23]
  1.upto(64) do
    input.each do |length|
      list.rotate!(current_position)
      list[0...length] = list[0...length].reverse
      list.rotate!(-current_position)

      current_position = (current_position + length + skip_size) % list.length
      skip_size += 1
    end
  end

  dense_hash = []
  list.each_slice(16) do |sublist_of_16|
    dense_hash << sublist_of_16.reduce(:^)
  end

  output = ''
  dense_hash.each { |number| output += number.to_s(16).rjust(2, '0') }
  output
end

$input = 'ljoxqyyw'
def f1
  used_count = 0
  0.upto(127) do |i|
    output_hash = knot_hash("#{$input}-#{i}")
    output_bits = output_hash.hex.to_s(2).rjust(128, '0')
    used_count += output_bits.scan(/1/).length
  end

  puts used_count
end

def f2
  grid = []
  0.upto(127) do |i|
    output_hash = knot_hash("#{$input}-#{i}")
    output_bits = output_hash.hex.to_s(2).rjust(128, '0')
    grid << output_bits.gsub('1', '#').split('')
    # used_count += output_bits.scan(/1/).length
  end

  grid.each do |row|
    row.each do |cell|
      if cell == '#'

      end
    end
  end
end

f2
