=begin
  Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).
=end

vowels = %w[a e i o u y]
vowels_hash = {}

('a'..'z').each.with_index(1) do |letter, index|
  vowels_hash[letter.to_sym] = index if vowels.include?(letter)
end

puts vowels_hash
