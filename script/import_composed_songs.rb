input = Rails.root.join("script", "composed_sequences.csv")

sequences = []

File.open(input, "r") do |f|
  while line = f.gets
    line.chomp!
    split_line = line.split(',')
    method, sequence = split_line[0], split_line[1..-1]
    sequences << [method, sequence]
  end
end

sequences.each do |method, sequence|
  Sequence.new_from_csv(sequence.join(','), method)
end


