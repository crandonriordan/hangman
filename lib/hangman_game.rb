require 'set'
require_relative 'hangman'
require 'json'

class HangmanGame
    include Hangman

    attr_accessor :word, :num_of_incorrect_guesses, :guessed_letters, :word_set

    def initialize
        @word = get_random_word.downcase
        @word_set = Set.new(word.chars)
        @num_of_incorrect_guesses = 0;
        @guessed_letters = Set.new;
    end

    def start
        puts 'Welcome to Hangman... Have fun!'
        puts 'Please enter "load" if you would like to start from a previous game'
        response = gets.chomp

        if response.eql? 'load'
            new_game = load
        end

        guess = ''
        while !(@word_set.eql? @guessed_letters) && new_game.nil?
            display_board
            guess = get_player_guess
            handle_player_guess(guess)
        end

        unless new_game.nil?
            new_game.start
        end

        puts 'Congrats! You won'
    end

    def get_player_guess
       puts 'Please enter your best guess or "save" if you wish to save'
       guess = gets.chomp
       return  guess
    end

    def handle_player_guess(guess)
        if guess.eql? 'save'
            save_game
            return
        end
        
        guess = guess[0]

        if @word.include? guess
            @guessed_letters.add(guess)
        else
            @num_of_incorrect_guesses += 1
        end
    end

    def load
        puts 'Please enter the file name you would like to open'
        file_name = gets.chomp
        begin
            obj = File.read(file_name + ".json")
            return HangmanGame.from_json(obj)
        rescue
            raise "File not found"
        end
    end

    def save_game
        puts 'Please enter the file name you would like to save as'
        file_name = gets.chomp + ".json"
        begin
            puts 'Writing to file...'
            f = File.new(file_name, "w")
            f.write(self.to_json)
            puts 'Closing file...'
            f.close
        rescue
            raise "Issue writing to file"
        end
    end

    def display_board
        puts "Number of incorrect guesses #{@num_of_incorrect_guesses}"
        display_arr = @word.chars.map do |c|
            @guessed_letters.include?(c) ? c : '_'
        end
    
        p display_arr
    end

    def to_json
        {'word' => @word, 'word_set' => @word_set.to_a,
             'num_of_incorrect_guesses' => @num_of_incorrect_guesses, "guessed_letters" => @guessed_letters.to_a}.to_json
    end

    def self.from_json string
        data = JSON.load string
        obj = self.new
        obj.word = data['word']
        obj.word_set = Set.new(data['word_set'])
        obj.num_of_incorrect_guesses = data['num_of_incorrect_guesses']
        obj.guessed_letters = data['guessed_letters'].nil? ? Set.new : Set.new(data['guessed_letters'])
        return obj
    end
end

game = HangmanGame.new
game.start
