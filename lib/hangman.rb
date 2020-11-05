module Hangman
    def get_random_word
        words = IO.readlines('5desk.txt', chomp: true)
        word = words.sample
        until word.length >= 5 && word.length <= 12 do
            word= words.sample
        end

        return word
    end
end