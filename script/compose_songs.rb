files = Dir['script/data/*.csv']

def extract_chords(title)
  open("#{title}").read.gsub(/\s+/, ",").split(",").select{|x| x != ""}
end

chords = []
files.each do |s|
  chords << extract_chords(s)
end

unique_chords = chords.flatten.uniq
num_chords = unique_chords.size

output = Rails.root.join("script", "composed_sequences.csv")

File.open(output, "w") do |f|
end

300.times do |i|
  seed = []
  4.times do
    seed << unique_chords[rand(num_chords)]
  end

  Composer2.compose(seed, :all, output)
  puts "#{i}/300"
end

