require 'byebug'
require 'pry'
require 'set'

puts 'START'

class WordChainer
  attr_accessor :dictionary, :current_words, :all_seen_words

  def initialize
    @dictionary = IO.readlines('dictionary.txt').map { |word| word.chomp }.to_set
  end
  
  def adjacent_words(main_word) #returns arr of words
    arr_main_word = main_word.split("")
    @dictionary.select do |word|
      if word.length == main_word.length && main_word != word
        count = 0
        arr_main_word.each_with_index { |char, idx| count += 1 if main_word[idx] == word[idx] }
        word if count >= main_word.length - 1
      end
    end
  end

  def run(source, target)
    #debugger
    start = Time.new
    @current_words = [source]
    @all_seen_words = { source => nil }

    @current_words = explore_current_words(@current_words) until @current_words.empty? || @all_seen_words.include?(target)
    p build_path(target)
    finish = Time.now

    diff = finish - start
  end

  def explore_current_words(current_words)
    new_current_words = []
    current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        unless @all_seen_words.include?(adjacent_word)
          new_current_words << adjacent_word
          @all_seen_words[adjacent_word] = current_word 
        end
      end
    end
    #new_current_words.each { |word, previous_word| p "#{word}: #{previous_word}"}
    new_current_words
  end

  def build_path(target)
    path = [target]
    done = false
    until done == true
      @all_seen_words.each do |word, previous_word| 
        if path.last == word
          if previous_word == nil
            done = true
            next
          else
            path << previous_word
          end
        end
      end
    end
    path
  end

end

binding.pry

puts 'END'