require "./hangman_draw"
class Game
  attr_accessor :word, :line_vector

  def initialize(word)
    @word = word
    @line_vector = Array.new(word.length, "_")
    @wrong_letters = []
    @right_letters = []
    @number_of_turns = 0
  end

  def add_lines
    @line_vector
  end

  def check_letter(word, letter)
    word.include?(letter)
  end

  def incorrect_letters(word, letter)
    @wrong_letters.push(letter) unless word.include?(letter)
    @wrong_letters
  end

  def get_indexes(correct_letter)
    found_index = []
    word.chars.each_with_index do |value, index|
      found_index.push(index) if word[value] == correct_letter
    end
    found_index
  end

  def replace_letter(index_repl, line_vector, replacement_letter)
    index_repl.each do |item|
      line_vector[item] = replacement_letter
    end
  end

  def draw_shape(guess)
    puts HANGMANPICS[guess]
  end

  def save_shape(_nr_of_turns)
    @number_of_turns
  end
end
