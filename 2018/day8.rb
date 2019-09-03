require 'basic_file_reader'

class Node
  attr_reader :children_count, :metadata_count, :children, :metadata

  def initialize(children_count, metadata_count)
    @children_count = children_count
    @metadata_count = metadata_count
    @children = []
    @metadata = []
  end

  def add_child(child)
    @children << child
  end

  def add_metadata(metadata)
    @metadata += [*metadata]
  end

  def metadata_sum
    metadata.reduce(&:+)
  end

  def value
    return metadata_sum if @children_count.zero?
    @metadata.reduce(0) { |sum, i| sum + (@children[i - 1].nil? ? 0 : @children[i - 1].value) }
  end
end

class Tree
  attr_reader :nodes, :input, :index

  def initialize
    @nodes = []
    @index = 0
    @input = BasicFileReader.content(file_name: 'input_day8').split(' ').map(&:to_i)

    generate_nodes
  end

  def metadata_nodes_sum
    nodes.map(&:metadata_sum).reduce(&:+)
  end

  private

  def generate_nodes
    return if @index >= @input.size

    @nodes << node = Node.new(@input[@index], @input[@index + 1])
    1.upto(node.children_count) do |i|
      @index += 2
      node.add_child(generate_nodes)
    end

    node.add_metadata(@input[@index + 2...@index + 2 + node.metadata_count])
    @index += node.metadata_count

    node
  end
end

# Quiz 1
puts Tree.new.metadata_nodes_sum

# Quiz 2
puts Tree.new.nodes[0].value
