=begin
Идеальный вес.
Программа запрашивает у пользователя имя и рост и выводит идеальный вес по формуле <рост> - 110,
после чего выводит результат пользователю на экран с обращением по имени.
Если идеальный вес получается отрицательным, то выводится строка "Ваш вес уже оптимальный"
=end

puts "Please, enter your name: "
name = gets.chomp.capitalize

puts "Please, enter your height: "
height = gets.chomp.to_i

if height == 0
  puts "Incorrect height, please try again"
else
  ideal_weight = height.to_i - 110
  if ideal_weight < 0
    puts "#{name}, you already have an ideal weight"
  else
    puts "#{name}, your ideal weight is #{ideal_weight}"
  end
end
