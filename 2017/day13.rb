file = open 'input13'
$list = {}
file.each do |line|
  depth, range = line.gsub("\n", '').split(': ')
  $list[depth.to_i] = range.to_i
end
file.close

def f1
  sum = 0
  0.upto($list.keys.last) do |i|
    next unless $list[i]
    sum += i * $list[i] if i % ($list[i] * 2 - 2) == 0
  end
  p sum
end

def f2
  delay = 0
  loop do
    caught = false
    0.upto($list.keys.last) do |i|
      next unless $list[i]
      if ((i + delay) % ($list[i] * 2 - 2)) == 0
        caught = true
        break
      end
    end
    if caught
      delay += 1
    else
      p delay
      exit
    end
  end
end

f2