class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  def guess(alpha)

    if !alpha || (alpha.match /^([\W\d]|$)/)
      raise ArgumentError
    elsif alpha.match /[A-Z]/
      return false
    end

    if (@word.include? alpha)
      if !(@guesses.include? alpha)
        @guesses += alpha
      else
        return false
      end
    elsif !(@wrong_guesses.include? alpha)
      @wrong_guesses += alpha
    else
      return false
    end
    return true
  end

  def word_with_guesses
    result = @word.dup
    @word.each_char{|char|
      if !@guesses.include? char
        result.gsub! /#{char}/, "-"
      end
    }
    return result
  end

  def check_win_or_lose
    if self.word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length >= 7
      return :lose
    end
    return :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
