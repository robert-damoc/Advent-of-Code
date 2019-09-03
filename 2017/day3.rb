def matrix_size(x)
  i = 1
  root = i * i

  until root >= x
    i += 2
    root = i * i
  end

  i
end

def is_in_position_with_offset?(x, n, offset, array)
  corner_salt = n - 1
  i = (array.length - 1 + offset) % array.length

  1.upto(4) do
    if x == array[i]
      return true
    end

    i -= corner_salt
  end

  false
end

def first_quiz
  input = 277678
  return 0 if input == 1

  size = matrix_size(input)
  max_element = size * size
  output = (size - 1) / 2

  number_of_elements_on_last_shell = (size * 2 - 2) * 2
  last_shell_elements = [*(max_element - number_of_elements_on_last_shell + 1)...(max_element + 1)].sort

  corner_salt = size - 2

  0.upto(corner_salt / 2) do |offset|
    return output + ((corner_salt + 1) / 2) - offset if is_in_position_with_offset?(input, size, offset, last_shell_elements)
    return output + ((corner_salt + 1) / 2) - offset if is_in_position_with_offset?(input, size, -offset, last_shell_elements)
  end

  output
end

p "first_quiz: #{first_quiz}"