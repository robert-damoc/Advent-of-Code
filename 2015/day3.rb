file = open 'input3'
$input = file.read.gsub("\n", '')
file.close

def f1
  houses = ['0,0']
  x, y = 0, 0

  $input.split('').each do |c|
    case c
    when '<'
      x -= 1
    when '^'
      y += 1
    when '>'
      x += 1
    else
      y -= 1
    end

    houses |= ["#{x},#{y}"]
  end

  puts houses.length
end

def f2
  houses = ['0,0']
  x1, x2, y1, y2 = 0, 0, 0, 0

  $input.split('').each_with_index do |c, i|
    index = (i % 2) + 1
    case c
    when '<'
      eval "x#{index} -= 1"
    when '^'
      eval "y#{index} += 1"
    when '>'
      eval "x#{index} += 1"
    else
      eval "y#{index} -= 1"
    end

    houses |= ["#{x1},#{y1}", "#{x2},#{y2}"]
  end

  puts houses.length
end

f2