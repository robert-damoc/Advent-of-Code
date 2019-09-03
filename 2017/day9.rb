file = open 'input9'
$content = file.read.gsub("\n", '')
file.close

$content.gsub!(/!./, '')

def f1
  $content.gsub!(/<.*?>/, '')

  worth, output = 0, 0
  $content.split('').each do |character|
    if character == '{'
      worth += 1
    elsif character == '}'
      output += worth
      worth -= 1
    end
  end

  puts output
end

def f2
  output = 0
  garbages = $content.scan(/<.*?>/)
  garbages.each do |garbage|
    output += garbage.length - 2
  end

  puts output
end

f2