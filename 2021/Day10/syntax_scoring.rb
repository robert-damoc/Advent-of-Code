require 'basic_file_reader'

class ChunksLine
  attr_reader :chunks, :penality

  PENALITIES = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }.freeze
  POINTS = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }.freeze
  OPEN_CHARS = ['(', '[', '{', '<'].freeze
  CLOSE_CHARS_PAIR = { ')' => '(', ']' => '[', '}' => '{', '>' => '<' }.freeze
  OPEN_CHARS_PAIR = { '(' => ')', '[' => ']', '{' => '}', '<' => '>'}.freeze
  AUTOCOMPLETE_SCORE_MULTIPLIER = 5

  def initialize(chunks)
    @chunks = chunks.split('')
    @penality = 0
  end

  def corrupted?
    @stack = []

    chunks.each do |char|
      if OPEN_CHARS.include?(char)
        @stack << char
      elsif CLOSE_CHARS_PAIR[char] != @stack.pop
        @penality = PENALITIES[char]
        return false
      end
    end

    true
  end

  def autocomplete_score
    corrupted? unless @stack

    @stack.map { |char| OPEN_CHARS_PAIR[char] }
          .reverse
          .inject(0) { |sum, char| sum * AUTOCOMPLETE_SCORE_MULTIPLIER + POINTS[char] }
  end
end

class SyntaxScoring
  attr_reader :corrupted_lines, :incomplete_lines

  def initialize
    @corrupted_lines = []
    @incomplete_lines = []

    BasicFileReader.lines(file_name: 'input') do |line|
      chunks = ChunksLine.new(line)

      if chunks.corrupted?
        incomplete_lines << chunks
      else
        corrupted_lines << chunks
      end
    end
  end

  def total_syntax_error
    @total_syntax_error ||= corrupted_lines.map(&:penality).reduce(:+)
  end

  def middle_score
    @incomplete_lines.map(&:autocomplete_score).sort[(@incomplete_lines.size - 1) / 2]
  end
end

ss = SyntaxScoring.new
p ss.total_syntax_error
p ss.middle_score
