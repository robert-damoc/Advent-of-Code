require 'basic_file_reader'

class Password
  attr_accessor :body, :policy_low, :policy_high, :policy_char

  def initialize(line)
    policy, @body = line.split(':').map(&:strip)

    policy_range, @policy_char = policy.split(' ')
    @policy_low, @policy_high = policy_range.split('-').map(&:to_i)
  end

  def valid_with_old_policy?
    body.split('').tally[policy_char]&.between?(policy_low, policy_high)
  end

  def valid_with_new_policy?
    (body[policy_low - 1] == policy_char) ^ (body[policy_high - 1] == policy_char)
  end
end

passwords = []
BasicFileReader.lines(file_name: 'input') do |line|
  passwords << Password.new(line)
end

valid_passwords = 0
passwords.each do |password|
  valid_passwords += 1 if password.valid_with_old_policy?
end
p valid_passwords

valid_passwords = 0
passwords.each do |password|
  valid_passwords += 1 if password.valid_with_new_policy?
end
p valid_passwords
