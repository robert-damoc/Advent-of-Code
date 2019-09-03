file = open 'input10'
$Lengths = file.read.gsub("\n", '')
file.close

def f1
  list = [*0...256]
  skip_size, current_position = 0, 0

  $Lengths.split(',').map(&:to_i).each do |length|
    list.rotate!(current_position)
    list[0...length] = list[0...length].reverse
    list.rotate!(-current_position)

    current_position = (current_position + length + skip_size) % list.length
    skip_size += 1
  end

  p list[0] * list[1]
end

def f2
  list = [*0...256]
  skip_size, current_position = 0, 0

  $Lengths = $Lengths.split('').map(&:ord) + [17, 31, 73, 47, 23]
  1.upto(64) do
    $Lengths.each do |length|
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

  dense_hash.each { |number| print number.to_s(16).rjust(2, '0') }
  puts
end

f2