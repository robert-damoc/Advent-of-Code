# frozen_string_literal: true

class TicketsSystem
  def initialize
    @rules = {}
    @nearby_tickets = []

    init_from_file
  end

  def ticket_scanning_error_rate
    @nearby_tickets.flat_map { |ticket| ticket.reject(&method(:match_any_rule?)) }.sum
  end

  def departure_values_multiplied
    valid_ordering.sort_by(&:last)
                  .select { |field, _| field.start_with?('departure') }
                  .map(&:last)
                  .yield_self { |indices| @my_ticket.values_at(*indices).reduce(:*) }
  end

  private

  def valid_ordering
    all_valid_positions.each_with_object({}) do |(field, positions), result|
      num = positions.first
      result[field] = num
      all_valid_positions.each { |_, pos| pos.delete(num) }
    end
  end

  def all_valid_positions
    @all_valid_positions ||= @rules.map { |name, ranges| [name, valid_positions(ranges)] }
                                   .sort_by { |_, positions| positions.count }
  end

  def valid_positions(ranges)
    (0...@rules.count).select do |i|
      valid_tickets.all? do |ticket|
        ranges.any? { |range| range.cover?(ticket[i]) }
      end
    end
  end

  def valid_tickets
    @valid_tickets ||= @nearby_tickets.select do |ticket|
      ticket.all? { |ticket_number| match_any_rule?(ticket_number) }
    end
  end

  def match_any_rule?(ticket_number)
    @rules.any? do |_, ranges|
      ranges.any? { |range| range.cover?(ticket_number) }
    end
  end

  def init_from_file
    chunks = File.read('input').split("\n\n")

    init_rules(chunks[0])
    init_my_ticket(chunks[1])
    init_nearby_tickets(chunks[2])
  end

  def init_rules(chunk)
    reg_exp = /(.+): (\d+)\-(\d+) or (\d+)\-(\d+)/

    chunk.split("\n").each do |line|
      matches = reg_exp.match(line)

      @rules[matches[1]] = [
        matches[2].to_i..matches[3].to_i,
        matches[4].to_i..matches[5].to_i
      ]
    end
  end

  def init_my_ticket(chunk)
    @my_ticket = chunk.split("\n").last.split(',').map(&:to_i)
  end

  def init_nearby_tickets(chunk)
    @nearby_tickets = chunk.split("\n")[1..].map { |ticket| ticket.split(',').map(&:to_i) }
  end
end

ts = TicketsSystem.new
# p ts.ticket_scanning_error_rate
p ts.departure_values_multiplied
