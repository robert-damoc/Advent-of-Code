require 'basic_file_reader'

class Passport
  HGT_REGEX = /^(\d+)(cm|in)$/.freeze
  HCL_REGEX = /^#[a-f0-9]{6}$/.freeze
  PID_REGEX = /^[0-9]{9}$/.freeze

  def self.passports_factory
    [].tap do |passports|
      options = {}

      BasicFileReader.lines(file_name: 'input').each do |line|
        line.split(' ').each do |pair|
          key, value = pair.split(':')
          options[key] = value
        end

        if line.empty?
          passports << Passport.new(options)
          options = {}
        end
      end

      passports << Passport.new(options)
    end
  end

  attr_accessor :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid

  def initialize(options)
    options.each { |k, v| public_send("#{k}=", v) }
  end

  def required_fields_present?
    byr && iyr && eyr && hgt && hcl && ecl && pid
  end

  def valid?
    return false unless required_fields_present?
    return false unless valid_years?
    return false unless valid_height?
    return false unless valid_colors?
    return false unless PID_REGEX.match?(pid)

    true
  end

  private

  def valid_years?
    return false unless byr.to_i.between?(1920, 2002)
    return false unless iyr.to_i.between?(2010, 2020)
    return false unless eyr.to_i.between?(2020, 2030)

    true
  end

  def valid_height?
    hgt_groups = hgt.scan(HGT_REGEX).flatten

    case hgt_groups[1]
    when 'cm'
      return false unless hgt_groups[0].to_i.between?(150, 193)
    when 'in'
      return false unless hgt_groups[0].to_i.between?(59, 76)
    else
      return false
    end

    true
  end

  def valid_colors?
    return false unless HCL_REGEX.match?(hcl)
    return false unless %w[amb blu brn gry grn hzl oth].include?(ecl)

    true
  end
end

passports = Passport.passports_factory

p passports.count(&:required_fields_present?)
p passports.count(&:valid?)
