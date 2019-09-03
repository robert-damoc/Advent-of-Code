require 'date'

class Duration
  attr_reader :start_time, :action

  def initialize(start_time:, action:)
    @start_time = start_time.to_i
    @action = action
  end
end

class Shift
  attr_reader :date, :id, :durations

  def initialize(date:, id:, durations:)
    @date = date
    @id = id
    @durations = []
    durations.each do |duration|
      @durations << Duration.new(start_time: duration[0].split(':')[1], action: duration[1])
    end
  end

  def asleep_minutes
    total_minutes = []

    asleep_time = nil
    @durations.each do |duration|
      if duration.action == :asleep
        asleep_time = duration.start_time
      else
        total_minutes += [*(asleep_time...duration.start_time)]
      end
    end

    total_minutes
  end

  def self.factory(shifts)
    shifts = shifts.map do |shift|
      row = shift.gsub('[', '').gsub(']', '')
      commands = row.split(' ')
      day = commands.first.split('-').map(&:to_i)
      minutes = commands[1].split(':').map(&:to_i)
      date = DateTime.new(day[0], day[1], day[2], minutes[0], minutes[1])
      { row: shift, date: date }
    end.sort_by { |row| row[:date] }.map { |row| row[:row] }

    [].tap do |obj_shifts|
      id = nil
      date = nil
      durations = []

      shifts.each do |shift|
        info = shift[19..-1]

        c_id = info.scan(/#\d+\b/)[0]

        if c_id
          if id
            obj_shifts << Shift.new(id: id, date: date, durations: durations)
            date = nil
            durations = []
          end
          id = c_id
        end

        date, hour = shift[1..16].split(' ')

        unless c_id
          action = info.match(/falls/) ? :asleep : :awake
          durations << [hour, action]
        end
      end

      obj_shifts << Shift.new(id: id, date: date, durations: durations)
    end
  end
end

def get_file_input
  shifts = []

  file = open 'input_day4'
  file.each do |line|
    shifts << line.gsub("\n", '')
  end
  file.close

  Shift.factory(shifts)
end

def highest_hz(arr)
  arr.each_with_object(Hash.new(0)) { |el, memo| memo[el] += 1 }
end

def shared_thing
  shifts = get_file_input
  asleep_times = Hash.new([])

  shifts.each do |shift|
    asleep_times[shift.id] += shift.asleep_minutes
  end

  asleep_times
end

def first_quiz
  asleep_times = shared_thing

  sleepier_guard_id = asleep_times.select { |_, v| v.size == asleep_times.values.map(&:size).max }.keys[0]

  asleep_times.each do |k, v|
    if k == sleepier_guard_id
      hz_arr = highest_hz(v)
      return hz_arr.select { |_, v| v == hz_arr.values.max }.keys[0] * k[1..-1].to_i
    end
  end
end

def second_quiz
  asleep_times = shared_thing

  all_hzs = {}
  asleep_times.each do |k, v|
    hz_arr = highest_hz(v)
    all_hzs[k] = hz_arr.select { |_, v| v == hz_arr.values.max }
  end

  # all_hzs.select { |_, v| v == all_hzs. }
  all_hzs.map do |k, v|
    [k, v.select { |mk, mv| mv == v.values.max }.first].flatten
  end
end

puts "result  first_quiz: #{first_quiz}"
puts "result second_quiz: #{second_quiz}"
