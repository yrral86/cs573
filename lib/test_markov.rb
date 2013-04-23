$:.unshift File.dirname(__FILE__)
require 'markov'

fn = 'markov.model'

m = MarkovChain.new
m.record_occurance(['A','B','C','E'])
m.record_occurance(['A','B','C','D'])

m.save_model(fn)

m2 = MarkovChain.new
m2.load_model(fn)

m2.calculate_probabilities
10.times do
  puts m2.next_note(['A','B','C'])
end
