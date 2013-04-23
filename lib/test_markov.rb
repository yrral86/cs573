$:.unshift File.dirname(__FILE__)
require 'markov'

m = MarkovChain.new
m.record_occurance(['A','B','C','E'])
m.record_occurance(['A','B','C','D'])
m.calculate_probabilities
10.times do
  puts m.next_note(['A','B','C'])
end
