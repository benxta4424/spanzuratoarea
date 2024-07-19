require "./hangman_draw"
class Game
  attr_accessor :word

  def initialize(word)
    self.word = word
  end

  def add_lines(words)
    line_vector = []
    length = words.length - 1

    length.times do
      line_vector.push("_")
    end
    line_vector
  end

  def check_letter(word, letter)
    word.include?(letter)
  end

  def get_indexes(correct_letter)
    found_index = []
    word.chars.each_with_index do |value, index|
      found_index.push(index) if word[value] == correct_letter
    end
    found_index
  end

  def replace_letter(index_repl,line_vector,replacement_letter)
    index_repl.each do |item|
      line_vector[item]=replacement_letter
    end
  end

  def draw_shape(guess)
    puts HANGMANPICS[guess] 
  end

end
