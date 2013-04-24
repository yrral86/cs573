dir = File.dirname(__FILE__)
$:.unshift dir
require 'markov'

fn = File.join(dir, 'markov.model')
unless File.file?(fn)
  files = Dir[File.join(dir, 'data/') + '*.csv']

  def extract_chords(title)
    open("#{title}").read.gsub(/\s+/, ",").split(",").select{|x| x != ""}
  end

  chords = []
  files.each do |s|
    chords << extract_chords(s)
  end

  m = MarkovChain.new

  chords.each do |s|
    s.each_cons(4) do |c|
      m.record_occurance(c)
    end
  end

  m.calculate_probabilities
  m.save_model(fn)
end

m = MarkovChain.new
m.load_model(fn)

if (ARGV.size != 3)
  puts "Usage: #{$0} chord_name_1 chord_name_2 chord_name_3"
  exit
end

song = m.compose(ARGV)

puts song.join ","
