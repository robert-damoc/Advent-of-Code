file = open 'input12'
$graph = {}
file.each do |line|
  node, neighbours = line.gsub("\n", '').split(' <-> ')
  $graph[node.to_i] = neighbours.split(', ').map(&:to_i)
end
file.close

def f1
  queue, visited, count = [0], [], 0
  until queue.empty?
    queue.delete(c_node = queue.first)
    visited << c_node

    queue += $graph[c_node] - visited
    count += 1
  end
  p count
end

def f2
  count = 0
  until $graph.length.zero?
    queue, visited = [$graph.first[0]], []
    until queue.empty?
      queue.delete(c_node = queue.first)
      visited << c_node

      queue += $graph[c_node] - visited
      $graph.delete(c_node)
    end
    count += 1
  end
  p count
end

f2