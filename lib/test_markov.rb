$:.unshift File.dirname(__FILE__)
require 'markov'

fn = 'markov.model'

m = MarkovChain.new
m.record_occurance(['A','B','C','E'])
m.record_occurance(['A','B','C','D'])
m.record_occurance(['B','C','E','A'])
m.record_occurance(['B','C','E','C'])
m.record_occurance(['C','E','A','B'])
m.record_occurance(['C','E','A','B'])

m.save_model(fn)

m2 = MarkovChain.new
m2.load_model(fn)

m2.calculate_probabilities
10.times do
  puts m2.next_chord(['A','B','C'])
end

puts m2.compose(['A','B','C']).inspect
