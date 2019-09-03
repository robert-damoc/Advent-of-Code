require 'json'

def first_quiz
  # root = `grep -o -E '[a-z]+' input_day7 | sort | uniq -u`
  # puts root

  file = open 'input_day7'
  content = file.read
  file.close

  programs = content.scan(/[a-z]+/)
  puts programs.detect { |program| programs.count(program) == 1 }
end

def get_tree_sum(root, tree)
  sum = tree[root][:weight]

  [*tree[root][:children]].each do |child|
    sum += get_tree_sum(child, tree)
  end

  sum
end

def second_quiz
  nodes_tree = {}

  file_name = 'input_day7_anca'
  file = open file_name
  file.each do |line|
    node_with_weight, children_list = line.gsub("\n", '').split(' -> ')
    node, weight = node_with_weight&.split(' ')

    nodes_tree[node] = {
      weight: /(\d+)/.match(weight)[0].to_i,
      children: children_list&.split(', ')
    }
  end
  file.close

  root = `grep -o -E '[a-z]+' #{file_name} | sort | uniq -u`.gsub("\n", '')
  output = []

  queue = [root]
  until queue.empty?
    current_node = queue.first
    queue -= [current_node]
    queue |= nodes_tree[current_node][:children] if nodes_tree[current_node][:children]
    sums = {}

    next unless nodes_tree[current_node][:children]

    nodes_tree[current_node][:children].each do |child|
      sum = get_tree_sum(child, nodes_tree)
      sums[sum] ||= []
      sums[sum] << child
    end

    if sums.length > 1
      diff_sum = sums.select { |k, v| v.length == 1 }
      delta = sums.keys[0] - sums.keys[1]
      output << {
        c_node: current_node,
        result: nodes_tree[diff_sum[diff_sum.keys[0]].first][:weight] - delta.abs,
        difference: diff_sum,
        tree_diff: sums
      }
    end
  end

  output
end

# first_quiz
puts "second_quiz: #{second_quiz.last}"
