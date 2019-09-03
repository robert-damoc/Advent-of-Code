file = open 'input1'
$input = file.read.gsub("\n", '')
file.close

def f1
  output = 0

  $input.split('').each do |c|
    output += 1 if c == '('
    output -= 1 if c == ')'
  end

  puts output
end

def f2
  output = 0

  $input.split('').each_with_index do |c, i|
    output += 1 if c == '('
    output -= 1 if c == ')'

    if output < 0
      puts i + 1
      exit
    end
  end
end

f2