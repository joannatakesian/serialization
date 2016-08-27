require 'yaml'

class Hangman
    
    def initialize
        rules
        if @load_game != "Y"
            choose_word
        end
        turn
    end
    
    def rules
        puts "Welcome to Hangman!"
        puts "---"
        puts "The computer has selected a secret word for you to guess."
        puts "You have six incorrect guesses. If you guess an incorrect"
        puts "letter, you'll see an 'X' under your game for each mistake."
        puts "Enter 'save' at any time to save your game."
        puts "Good luck!"
        puts "---"
        if File.exist?('save.yaml')
            puts "Would you like to load your last game? Y/N"
            @load_game = gets.chomp.upcase
            if @load_game == "Y"
                load
            end
        end
    end
    
    def choose_word
        words = []
        lines = File.readlines "5desk.txt"
        lines.each do |line|
            line.gsub!(/\s/,'')
            if line.length >= 5 && line.length <= 12
                words << line
            end
        end
        @secret_word = words.sample.downcase
        
    end
    
    def turn
        @solved = false
        
        if @load_game != "Y"
            @secret = []
            @errors = []
            @secret_word.length.times do
                @secret << "_"
            end
        end
        
        while @solved == false
            puts @secret.join("")
            puts @errors.join("")
            guess
            game_over
        end
    end
    
    def guess
        puts "Enter your guess:"
        @letter = gets.chomp.downcase
        
        if @letter == "save"
            save
        else
            @secret_word.split("").each_with_index do |char, index|
                if @letter == char
                    @secret[index] = char
                end
            end
        
            unless @secret_word.include?(@letter)
                @errors << "X"
            end
        end
    end
    
    def game_over
        if @secret.join('') == @secret_word
            @solved = true
            puts "Great job! The word was '#{@secret_word}'!"
        elsif @errors.size > 5
            @solved = true
            puts "Sorry, out of guesses. The word was '#{@secret_word}'."
        end
    end
    
    def save
        save_data = [@secret_word, @secret, @errors]
        File.new('save.yaml', 'w+') unless File.exist?('save.yaml')
        
        File.open('save.yaml', 'w+') do |file|
            file.write(save_data.to_yaml)
        end
        
        puts "saving game..."
        #puts YAML::dump(save_data)
        @solved = true
    end
    
    def load
        puts "loading game..."
        load_data = YAML.load_file("save.yaml")
        @secret_word = load_data[0]
        @secret = load_data[1]
        @errors = load_data[2]
    end
    
end

game = Hangman.new