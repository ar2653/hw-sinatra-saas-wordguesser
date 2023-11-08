require 'spec_helper'
require 'wordguesser_game'

describe WordGuesserGame do
  def guess_several_letters(game, letters)
    letters.chars do |letter|
      game.guess(letter)
    end
  end

  describe 'new' do
    it "takes a parameter and returns a WordGuesserGame object" do
      # Test the constructor to ensure it creates a WordGuesserGame
      # object with the correct attributes.
      @game = WordGuesserGame.new('glorp')
      expect(@game).to be_an_instance_of(WordGuesserGame)
      expect(@game.word).to eq('glorp')
      expect(@game.guesses).to eq('')
      expect(@game.wrong_guesses).to eq('')
    end
  end

  describe 'guessing' do
    context 'correctly' do
      before :each do
        # Test the game's handling of correct guesses and its return value.
        @game = WordGuesserGame.new('garply')
        @valid = @game.guess('a')
      end
      it 'changes correct guess list' do
        expect(@game.guesses).to eq('a')
        expect(@game.wrong_guesses).to eq('')
      end
      it 'returns true' do
        expect(@valid).not_to be false
      end
    end

    context 'incorrectly' do
      before :each do
        # Test the game's handling of incorrect guesses and its return value.
        @game = WordGuesserGame.new('garply')
        @valid = @game.guess('z')
      end
      it 'changes wrong guess list' do
        expect(@game.guesses).to eq('')
        expect(@game.wrong_guesses).to eq('z')
      end
      it 'returns true' do
        expect(@valid).not_to be false
      end
    end

    context 'same letter repeatedly' do
      before :each do
        # Test the game's handling of repeated guesses of the same letter.
        @game = WordGuesserGame.new('garply')
        guess_several_letters(@game, 'aq')
      end
      it 'does not change correct guess list' do
        # Check that repeated guesses of the same letter do not change the correct guess list.
        @game.guess('a')
        expect(@game.guesses).to eq('a')
      end
      it 'does not change wrong guess list' do
        # Check that repeated guesses of the same letter do not change the wrong guess list.
        @game.guess('q')
        expect(@game.wrong_guesses).to eq('q')
      end
      it 'returns false' do
        # Check that repeated guesses of the same letter return false.
        expect(@game.guess('a')).to be false
        expect(@game.guess('q')).to be false
      end
      it 'is case insensitive' do
        # Check that the game is case-insensitive for guesses.
        expect(@game.guess('A')).to be false
        expect(@game.guess('Q')).to be false
        expect(@game.guesses).not_to include('A')
        expect(@game.wrong_guesses).not_to include('Q')
      end
    end

    context 'invalid' do
      before :each do
      # Test the game's handling of invalid guesses.
        @game = WordGuesserGame.new('foobar')
      end
      it 'throws an error when empty' do
        expect { @game.guess('') }.to raise_error(ArgumentError)
      end
      it 'throws an error when not a letter' do
        expect { @game.guess('%') }.to raise_error(ArgumentError)
      end
      it 'throws an error when nil' do
        expect { @game.guess(nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'displayed word with guesses' do
    before :each do
      # Test the game's word_with_guesses method.
      @game = WordGuesserGame.new('banana')
    end

    @test_cases = {
      'bn' =>  'b-n-n-',
      'def' => '------',
      'ban' => 'banana'
    }

    @test_cases.each_pair do |guesses, displayed|
      it "should be '#{displayed}' when guesses are '#{guesses}'" do
        guess_several_letters(@game, guesses)
        expect(@game.word_with_guesses).to eq(displayed)
      end
    end
  end

  describe 'game status' do
    before :each do 
      # Test the game's win, lose, and play status.
      @game = WordGuesserGame.new('dog')
    end
    it 'should be win when all letters guessed' do
      guess_several_letters(@game, 'ogd')
      expect(@game.check_win_or_lose).to eq(:win)
    end
    it 'should be lose after 7 incorrect guesses' do
      guess_several_letters(@game, 'tuvwxyz')
      expect(@game.check_win_or_lose).to eq(:lose)
    end
    it 'should continue play if neither win nor lose' do
      guess_several_letters(@game, 'do')
      expect(@game.check_win_or_lose).to eq(:play)
    end
  end
end