require 'basic_file_reader'

class Problem
  @@n_s = 0
  @@normalization_hz = 1_000

  attr_reader :states, :rules, :iterations

  def initialize(initial_state, rules, iterations: 20)
    @states = [initial_state]
    @rules = {}
    @iterations = iterations

    rules.each do |rule|
      @rules[rule[0]] = rule[1]
    end
  end

  def solve
    1.upto(@iterations) do |it|
      current_state = '....' + @states.last + '....'

      next_state = Array.new(current_state.size) { '.' }
      (2...next_state.size - 2).each do |i|
        el = current_state[i - 2..i + 2]
        next_state[i] = @rules[el] || '.'
      end

      if @states.map { |q| q.scan(/\.*(#.*#)\.*/)[0][0] }.include? next_state.join.scan(/\.*(#.*#)\.*/)[0][0]
        if it >= 192 && it <= 197
          p next_state.join.scan(/(\.*)(#.*#)\.*/)[0][0].size
          sum = 0
          next_state.join.scan(/(\.*)(#.*#)\.*/)[0][1].each_char.with_index(0) do |z, i|
            sum += i + next_state.join.scan(/(\.*)(#.*#)\.*/)[0][0].size
          end
          p sum
        end
      end

      @states << next_state.join

      # normalize_states if (it % @@normalization_hz).zero?
    end

    normalize_states
    @states.map do |q|
      res = q.scan(/(\.*)(#.*#)\.*/)
      [res[0][0].size, res[0][1]]
    end.each do |q|
      p q
    end
  end

  def count_sharps
    o_index = @states.first.split('').find_index('#')
    last_state = @states.last

    sum = 0
    (-o_index..last_state.size - o_index).each do |i|
      if last_state[i + o_index] == '#'
        sum += i
      end
    end

    sum
  end

  private

  def normalize_states
    puts @@n_s += @@normalization_hz

    @states = [@states.first, @states.last]

    padding = Array.new((@states[1].size - @states[0].size) / 2) { '.' }.join
    @states[0] = padding + @states[0] + padding

    min_index = @states.map { |state| state.split('').find_index('#') }.min
    max_index = @states.map { |state| state.split('').map { |el| el == '#' }.rindex(true) }.max

    @states.map! { |state| state[min_index..max_index] }
  end
end

initial_state, *rules = BasicFileReader.lines(file_name: 'input_day12') do |line|
  initial_state = line.scan(/initial state: (.*)/)
  if initial_state.any?
    initial_state[0][0]
  else
    line.split(' => ')
  end
end

# problem = Problem.new(initial_state, rules)
# problem.solve
# p problem.count_sharps

problem = Problem.new(initial_state, rules, iterations: 50_000_000_000)
problem.solve
p problem.count_sharps
