=begin
Прямоугольный треугольник.
Программа запрашивает у пользователя 3 стороны треугольника и определяет, является ли треугольник прямоугольным,
используя теорему Пифагора (www-formula.ru) и выводит результат на экран.
Если треугольник является при этом равнобедренным (т.е. у него равны любые 2 стороны),
то дополнительно выводится информация о том, что треугольник еще и равнобедренный.
Если треугольник равносторонний, то выводится сообщение о том, что треугольник равнобедренный и равносторонний,
но не прямоугольный.
Подсказка: чтобы воспользоваться теоремой Пифагора, нужно сначала найти самую длинную сторону (гипотенуза)
и сравнить ее значение в квадрате с суммой квадратов двух остальных сторон. Если все 3 стороны равны,
то треугольник равнобедренный и равносторонний, но не прямоугольный.
=end

puts "Please, enter side a: "
a = gets.chomp.to_f

puts "Please, enter side b: "
b = gets.chomp.to_f

puts "Please, enter side c: "
c = gets.chomp.to_f

if a <= 0 || b <= 0 || c <= 0
  puts "Not enough or incorrect data, please try again"
else
  if a == b && b == c
    puts "Equilateral and isosceles triangle, but not right"
  else
    if (a ** 2 == b ** 2 + c ** 2) || (b ** 2 == a ** 2 + c ** 2) || (c ** 2 == a ** 2 + b ** 2)
      answer = "Right angle triangle"
      if a == b || b == c || a == c
        puts "#{answer} and isosceles"
      else
        puts answer
      end
    else
      puts "Scalene triangle"
    end
  end
end
