$rng_lo = 356261
$rng_hi = 846303

def valid_for_task1?(nr)
  array_nr = nr.to_s.chars.map(&:to_i)

  return false unless array_nr.slice_when { |d1, d2| d1 <= d2 }.count == array_nr.length
  return false if array_nr.slice_when { |d1, d2| d1 != d2 }.count == array_nr.length
  true
end

def valid_for_task2?(nr)
  return false unless valid_for_task1?(nr)

  array_nr = nr.to_s.chars.map(&:to_i)
  array_nr.slice_when { |d1, d2| d1 != d2 }.any? { |chunk| chunk.count == 2 }
end

def task1
  valid_passwords = []
  $rng_lo.upto($rng_hi).each do |nr|
    valid_passwords << nr if valid_for_task1? nr
  end

  valid_passwords.size
end

def task2
  valid_passwords = []
  $rng_lo.upto($rng_hi).each do |nr|
    valid_passwords << nr if valid_for_task2? nr
  end

  valid_passwords.size
end

p task1
p task2
