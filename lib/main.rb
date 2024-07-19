require "./new_game_class"
require "./hangman_draw"
all_file_words = File.open("google-10000-english-no-swears.txt", "r")
filtered_words = all_file_words.each_line.select { |items| items.strip.length > 5 && items.strip.length < 12 }
sampled_word = filtered_words.sample


game1 = Game.new(sampled_word)
vector_linii = game1.add_lines(sampled_word)
wrong_letter=0
figurine=[]
correct_letters=[]
wrong_letters=[]

puts sampled_word

until vector_linii.join==sampled_word

  puts
  print "Introdu litera:"
  introdu_litera = gets.chomp.to_s.downcase
  index_replacement = 0

  if game1.check_letter(sampled_word, introdu_litera)
    correct_letters.push(introdu_litera)
    index_replacement = game1.get_indexes(introdu_litera)
  

    game1.replace_letter(index_replacement,vector_linii,introdu_litera)
    puts

  else
    puts
    puts "Litera gresita bossu!"
    wrong_letter.push(introdu_litera)
    if wrong_letter<6
      wrong_letter+=1
      game1.draw_shape(wrong_letter)
    else
      puts "Ai pierdut! Cuvantul era:#{sampled_word}"
      break
    end
  

  end

  puts vector_linii.join(" ")


  if vector_linii.join==sampled_word.strip
    puts "AI ghicit!"
    break
  end
  
end
