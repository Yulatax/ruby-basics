=begin
  3. Заполнить массив числами фибоначчи до 100
=end

index = 0
fibonacci_numbers = [1, 1]

while (fibonacci_next = fibonacci_numbers[index] + fibonacci_numbers[index + 1]) < 100 do
  fibonacci_numbers << fibonacci_next
  index += 1
end

p fibonacci_numbers
