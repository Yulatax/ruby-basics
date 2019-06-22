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
a = gets.chomp.to_i

puts "Please, enter side b: "
b = gets.chomp.to_i

puts "Please, enter side c: "
c = gets.chomp.to_i

if a == 0 || b == 0 || c == 0
  puts "Not enough or incorrect data, please try again"
else
  if a == b && b == c
    puts "Equilateral and isosceles triangle, but not right"
  else
    answer = "Right triangle"
    if a > b && a > c
      res = b**2 + c**2
      if res == a**2
        puts answer
        if b == c
          puts "#{answer} and isosceles"
        end
      else
        puts "It is not a right triangle"
      end
    elsif b > a && b > c
      res = a**2 + c**2
      if res == b**2
        puts answer
        if a == c
          puts "#{answer} and isosceles"
        end
      else
        puts "It is not a right triangle"
      end
    else
      res = a**2 + b**2
      if res == c**2
        puts answer
        if a == b
          puts "#{answer} and isosceles"
        end
      else
        puts "It is not a right triangle"
      end
    end
  end
end