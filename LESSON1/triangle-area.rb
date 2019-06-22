=begin
Площадь треугольника.
Площадь треугольника можно вычислить, зная его основание (a) и высоту (h) по формуле: 1/2*a*h.
Программа должна запрашивать основание и высоту треугольника и возвращать его площадь.
=end

puts "Please, enter a triangle height: "
height = gets.chomp.to_i

puts "Please, enter a triangle base: "
base = gets.chomp.to_i

if height == 0 || base == 0
  puts "Something wrong, I can't calculate triangle area"
else
  triangle_area = 0.5*height*base
  puts "Triangle area is #{triangle_area}"
end