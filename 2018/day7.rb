require 'basic_file_reader'

class Vertex
  attr_reader :label, :next_list
  attr_accessor :locks

  def initialize(label:)
    @label = label
    @next_list = []
    @locks = 0
  end

  def add_neighbour(vertex)
    @next_list.push(vertex)
    vertex.locks += 1
  end
end

class GraphTree
  attr_reader :vertices, :queue, :visited

  def initialize
    @vertices = {}

    lines = read_from_file
    @queue = (lines.map { |q| q[0] }.uniq - lines.map { |q| q[1] }.uniq).sort
    @visited = []
  end

  def first_quiz
    until @queue.empty?
      current = @queue.delete_at(0)
      next if @visited.include?(current)
      next unless @vertices[current].locks.zero?

      @visited << current

      labels = @vertices[current].next_list.map(&:label)
      labels.each { |label| @vertices[label].locks -= 1 }
      @queue = (@queue | labels).sort
    end
    @visited.join
  end

  def second_quiz(workers_count: 2)
    second = 0
    workers = Array.new(workers_count)
    {}.tap do |letter_score_mapping|
      [*('A'..'Z')].each { |ch| letter_score_mapping[ch] = ch.ord - 4 }

      loop do
        workers.collect! do |worker|
          if @queue.empty? || !worker.nil?
            worker
          else
            current = nil
            loop do
              current = @queue.delete_at(0)
              break if current.nil?
              next if @visited.include?(current)
              next unless @vertices[current].locks.zero?
              break
            end
            @visited << current
            [current, letter_score_mapping[current]] if current
          end
        end

        break if workers.all?(&:nil?)

        workers.map! do |worker|
          if worker.nil?
            nil
          else
            worker[1] -= 1
            if worker[1] <= 0
              labels = @vertices[worker[0]].next_list.map(&:label)
              labels.each { |label| @vertices[label].locks -= 1 }
              @queue = (@queue | labels).sort
              nil
            else
              worker
            end
          end
        end
        second += 1
      end
    end
    second
  end

  private

  def read_from_file
    BasicFileReader.lines(file_name: 'input_day7') do |line|
      l1, l2 = *line.scan(/.*\b([A-Z])\b.*\b([A-Z])\b.*/).first
      @vertices[l1] = Vertex.new(label: l1) unless @vertices[l1]
      @vertices[l2] = Vertex.new(label: l2) unless @vertices[l2]
      @vertices[l1].add_neighbour(@vertices[l2])
      [l1, l2]
    end
  end
end

# puts GraphTree.new.first_quiz
puts GraphTree.new.second_quiz(workers_count: 5)
