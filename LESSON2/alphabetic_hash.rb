=begin
  Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).
=end

vowels = %w[a e i o u y]
vowels_hash = Hash.new

("a".."z").each_with_index do |letter, ind|
  if vowels.include?(letter)
    vowels_hash[letter.to_sym] = ind + 1
  end
end

puts vowels_hash
