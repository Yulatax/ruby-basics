=begin
  6. Сумма покупок. Пользователь вводит поочередно название товара, цену за единицу
  и кол-во купленного товара (может быть нецелым числом).
  Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп"
  в качестве названия товара. На основе введенных данных требуетеся:
  Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением - вложенный хеш,
  содержащий цену за единицу товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
  Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

item_name = ""
item_quantity = 0
item_price = 0

purchases = Hash.new
total = []

loop do
  puts "Item name: "
  item_name = gets.chomp.downcase

  break if item_name == "stop"

  puts "Item quantity: "
  item_quantity = gets.chomp.to_f

  puts "Item price: "
  item_price = gets.chomp.to_f

  if item_name.empty? || item_quantity <= 0 || item_price <= 0
    puts "Incorrect input, try again"
  else
    purchases[item_name.to_sym] = {price_for_item: item_price, items_quantity: item_quantity}
  end
end

purchases.each do |item, value|
  item_sum = (value[:price_for_item] * value[:items_quantity]).round(2)
  total << item_sum
  puts "#{item}: #{value}, sum for item: #{item_sum}"
end

puts "Total purchase is #{total.sum}"
