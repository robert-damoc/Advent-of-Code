file = open 'input11'
$moves = file.read.gsub("\n", '').split(',')
file.close

$inv = {
  'n' => 's',
  's' => 'n',
  'ne' => 'sw',
  'nw' => 'se',
  'sw' => 'ne',
  'se' => 'nw'
}

def f1(moves = $moves)
  h = moves.group_by { |move| move }.inject(Hash.new(0)) { |h, (k, v)| h[k] = v.size; h }
  hh = ['nw', 'ne', 'n'].inject({}) { |hh, dir| hh[dir] = (h[dir] - h[$inv[dir]]).abs; hh }
  [hh['nw'], hh['ne']].max + hh['n']
end

def f2
#   max_dist, dist = 0, 0
#   max_i = 0
#   $moves.each_with_index { |move, i|
#     max_dist, max_i = dist, i if (dist = f1($moves.take(i + 1))) > max_dist
#   }
#  [max_dist, max_i]
  f1($moves.take(6872))
end

puts f1
puts f2
