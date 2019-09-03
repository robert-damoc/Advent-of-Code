$input = []

file = open 'input2'
file.each { |line| $input << line.gsub("\n", '') }
file.close

def f1
  output = 0

  $input.each do |line|
    l, w, h = line.split('x').map(&:to_i)
    a1 = l * w
    a2 = w * h
    a3 = h * l

    output += 2 * (a1 + a2 + a3) + [a1, a2, a3].min
  end

  puts output
end

def f2
  output = 0

  $input.each do |line|
    l, w, h = line.split('x').map(&:to_i)

    output += l * w * h

    arr = [l, w, h]

    min1 = arr.min
    arr.delete_at(arr.index(min1))
    min2 = arr.min

    output += min1 + min1 + min2 + min2
  end

  puts output
end

f2