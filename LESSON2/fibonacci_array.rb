=begin
  3. Заполнить массив числами фибоначчи до 100
=end

ind = 0
fibonacci_numbers = [1, 1]

loop do
  fibonacci_next = fibonacci_numbers[ind] + fibonacci_numbers[ind + 1]
  break if fibonacci_next >= 100
  fibonacci_numbers << fibonacci_next
  ind += 1
end

p fibonacci_numbers
