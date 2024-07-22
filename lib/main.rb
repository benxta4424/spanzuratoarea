require "./new_game_class"
require "./hangman_draw"
all_file_words = File.open("google-10000-english-no-swears.txt", "r")
filtered_words = all_file_words.each_line.select { |items| items.strip.length > 5 && items.strip.length < 12 }
sampled_word = filtered_words.sample.strip
menu_option = 0
figurine = []
progress_directory_path = "/home/vboxuser/Desktop/proiecte/spanzuratoarea/lib/saved_files"
choose_game_save = ""
unload_previous_progress = nil

# play the game method
def play_new_game(sampled_word, progress_directory_path)
  wrong_letter = 0

  # create a new game
  game1 = Game.new(sampled_word)
  vector_linii = game1.add_lines
  print "Give name to the current game so i can save it as such for later:"
  game_name = gets.chomp.to_s
  puts

  puts sampled_word

  # until we guess or lose,the game keeps going
  until vector_linii.join == sampled_word
    
    puts
    # guess the letter
    print "Introdu litera:"
    introdu_litera = gets.chomp.to_s.downcase
    wrong_letters = game1.incorrect_letters(sampled_word, introdu_litera)
    if wrong_letters.include?(introdu_litera)
      print "Ai introdus deja #{introdu_litera},e gresita,introdu alta litera:"
      introdu_litera = gets.chomp.to_s.downcase
      index_replacement = 0
    else
      # save the current progress intro a file in the saved_files directory (after we serialize it with Marshall)
      puts "Save current progress!"
      if introdu_litera == "save"
        puts "AI salvat progresul curent! Numele jocului este:#{game_name}"

        file_name = "#{game_name}.txt"
        file_path = File.join(progress_directory_path, file_name)
        game1.save_shape(wrong_letter)
        File.open(file_path, "wb") do |file|
          Marshal.dump(game1, file)
        end
        puts "Progress saved!"
        break
      end
      index_replacement = 0

      # after we put the letter in,if its correct we put it inside the word at the correct position/s
      if game1.check_letter(sampled_word, introdu_litera)
        index_replacement = game1.get_indexes(introdu_litera)

        game1.replace_letter(index_replacement, vector_linii, introdu_litera)
        puts

      else
        puts
        puts "Litera gresita bossu!"
        puts "Litere gresite:#{game1.incorrect_letters(sampled_word, introdu_litera)}"
        # if we're wrong we begin to draw the figurine (a figurine vector)
        # we count the wrong turns
        # we display the figurine index
        # figurine index=wrong turn number
        if wrong_letter < 6
          wrong_letter += 1
          game1.draw_shape(wrong_letter)
        else
          puts "Ai pierdut! Cuvantul era:#{sampled_word}"
          break
        end

      end

      puts vector_linii.join(" ")

      if vector_linii.join == sampled_word.strip
        puts "AI ghicit!"
        break
      end
    end
  end
end

# we have the same rules but we just got rif of the save (why would someone make a save in a save)
def play_loaded_game(saved_game_progress)
  wrong_letters = saved_game_progress.incorrect_letters(word, introdu_litera)
  turns = 0
  word = saved_game_progress.word

  vector_linii = saved_game_progress.add_lines
  until vector_linii.join == saved_game_progress.word

    puts
    # guess the letter
    print "Introdu litera:"
    introdu_litera = gets.chomp.to_s.downcase
    index_replacement = 0

    if wrong_letters.include?(introdu_litera)
      print "Ai introdus deja #{introdu_litera},e gresita,introdu alta litera:"
      introdu_litera = gets.chomp.to_s.downcase
      index_replacement = 0
    else
      # after we put the letter in,if its correct we put it inside the word at the correct position/s
      if saved_game_progress.check_letter(saved_game_progress.word, introdu_litera)
        index_replacement = saved_game_progress.get_indexes(introdu_litera)

        saved_game_progress.replace_letter(index_replacement, vector_linii, introdu_litera)
        puts

      else
        puts
        puts "Litera gresita bossu!"
        puts "Litere gresite ghicite:#{saved_game_progress.incorrect_letters(word, introdu_litera)}"
        if turns < 6
          turns += 1
          saved_game_progress.draw_shape(turns)
        else
          puts "Ai pierdut! Cuvantul era:#{saved_game_progress.word}"
          break
        end

      end

      puts vector_linii.join(" ")

      if vector_linii.join == word.strip
        puts "AI ghicit!"
        break
      end
    end
  end
end

while menu_option != 1 && menu_option != 2

  puts "1.New game"
  puts "2.Load old saved game progress"
  print "Alege o optiune:"
  menu_option = gets.chomp.to_i

  case menu_option

  when 1
    play_new_game(sampled_word, progress_directory_path)
  when 2
    puts "Current game saves!"
    puts
    Dir.open("saved_files").each_child do |child|
      puts child
    end

    puts
    print "Choose the game you want to continue:"
    choose_game_save = gets.chomp.to_s

    file_path = File.join(progress_directory_path, choose_game_save)
    if File.exist?(file_path)
      File.open(file_path, "rb") do |file|
        unload_previous_progress = Marshal.load(file)
      end
    end
    play_loaded_game(unload_previous_progress)
  else
    puts "Save file '#{choose_game_save}' not found."
  end
end
