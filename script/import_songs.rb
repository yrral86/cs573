files = Dir['script/data/*.csv']

def extract_chords(title)
  open("#{title}").read.gsub(/\s+/, ",").split(",").select{|x| x != ""}
end

def name_to_file(chord_name)
  file = chord_name.gsub(/#/, 'sharp')
  file.gsub!(/b/, 'flat')
  file.gsub!(/-/, '')
  file.gsub!(/\//, '')
  "#{file}.ogg"
end

chords = []
files.each do |s|
  chords << extract_chords(s)
end

unique_chords = chords.flatten.uniq

unique_chords.each do |c|
  c = Chord.create(:name => c,
                   :file => name_to_file(c))
end

chords.each do |s|
  s.each_cons(10) do |c|
    seq = Sequence.new_from_csv(c.join(","), :human)
  end
end


