=begin
  5. Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
  Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
  (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
=end

puts "Enter a date:"
date = gets.chomp.to_i

puts "Enter a month (number):"
month = gets.chomp.to_i

puts "Enter a year: "
year = gets.chomp.to_i

months_hash = {
    1 => 31,
    2 => 28,
    3 => 31,
    4 => 30,
    5 => 31,
    6 => 30,
    7 => 31,
    8 => 31,
    9 => 30,
    10 => 31,
    11 => 30,
    12 => 31
}

months_hash[2] = 29 if ((year % 4 == 0 && year % 100 != 0) || (year % 4 == 0 && year % 400 == 0))

if (date <= 0 || month <= 0 || year <= 0) || date > 31 || month > 12 || year > 2100 || year < 1900
  puts "Incorrect input, try again"
else
  if date > months_hash[month]
    puts "Date is not correct"
  else
    date_number = months_hash.values.take(month - 1).sum + date
    puts "Day number of a year = #{date_number}"
  end
end
