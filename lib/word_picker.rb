require 'yaml'

class WordPicker
  def initialize
    @words = YAML.load_file('./words.yaml')
  end

  def get_words(num_words, prevent_duplicates: true)
    num_words.to_i.times.map do
      word = random_word
      @words -= [word] if prevent_duplicates
      word
    end
  end

  private

  def random_word
    rand_index = rand(0..@words.length)
    @words[rand_index]
  end
end
