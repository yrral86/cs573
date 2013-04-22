files = Dir['script/data/*.csv']

def extract_chords(title)
  open("#{title}").read.gsub(/\s+/, ",").split(",").select{|x| x != ""}
end

chords = []
files.each do |s|
  chords << extract_chords(s)  
end

chords.each do |s|
  s.each_cons(10) do |c|
    seq = Sequence.new_from_csv(c.join(","), :human)
  end
end


