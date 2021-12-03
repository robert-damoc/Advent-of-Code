require 'basic_file_reader'

class BinaryDiagnostic
  attr_reader :diagnostic_report, :report_line_size

  def initialize
    @diagnostic_report = BasicFileReader.lines(file_name: 'input')
    @report_line_size = @diagnostic_report.first.length
  end

  def power_consumption
    gamma_rate = [*0...report_line_size].map { |col| most_common_value(position: col) }.join.to_i(2)
    epsilon_rate = 2**report_line_size - 1 - gamma_rate

    gamma_rate * epsilon_rate
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end

  private

  def oxygen_generator_rating
    diagnostic_report.dup.tap do |oxygen_list|
      [*0...report_line_size].map do |col|
        break if oxygen_list.size <= 1

        common_value = most_common_value(report: oxygen_list, position: col)
        oxygen_list.select! { |element| element[col] == common_value }
      end
    end.first.to_i(2)
  end

  def co2_scrubber_rating
    diagnostic_report.dup.tap do |co2_list|
      [*0...report_line_size].map do |col|
        break if co2_list.size <= 1

        common_value = most_common_value(report: co2_list, position: col)
        co2_list.reject! { |element| element[col] == common_value }
      end
    end.first.to_i(2)
  end

  def most_common_value(position:, report: nil)
    report ||= diagnostic_report
    report.map { |report_line| report_line[position] }.tally.max_by { |k, v| [v, k] }.first
  end
end

binary_diagnostic = BinaryDiagnostic.new
p binary_diagnostic.power_consumption
p binary_diagnostic.life_support_rating
