def first_quiz
  registers = Hash.new(0)

  file = open 'input_day8'
  file.each do |line|
    action, condition = line.gsub("\n", '').split(' if ')
    condition.gsub!(/^(\w+)/, 'registers["\1"]')

    if eval condition
      key, act, val = action.split(' ')
      if act == 'inc'
        registers[key] += val.to_i
      else
        registers[key] -= val.to_i
      end
    end
  end

  file.close

  puts registers.max_by { |k, v| v };
end

def second_quiz
  registers = Hash.new(0)
  max = 0

  file = open 'input_day8'
  file.each do |line|
    action, condition = line.gsub("\n", '').split(' if ')
    condition.gsub!(/^(\w+)/, 'registers["\1"]')

    if eval condition
      key, act, val = action.split(' ')
      if act == 'inc'
        registers[key] += val.to_i
      else
        registers[key] -= val.to_i
      end

      max = registers[key] if registers[key] > max
    end
  end

  file.close

  puts max
end

# first_quiz
second_quiz