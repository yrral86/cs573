class MarkovChain
  def initialize(order=3)
    @occurrances = {}
    @probabilities = {}
    @order = order
  end

  # input: array of #(order + 1) chord names
  def record_occurance(chords)
    @probabilities = {} if @probabilities.keys.size > 0
    prior_key = chords[0..-2].join(",")
    @occurrances[prior_key] = {} if @occurrances[prior_key].nil?
    @occurrances[prior_key][chords[-1]] = 0 if @occurrances[prior_key][chords[-1]].nil?
    @occurrances[prior_key][chords[-1]] += 1
  end

  def calculate_probabilities
    @probabilities[:priorless] = {}

    # count occurances
    @occurrances.each_pair do |prior_key, next_chords|
      @probabilities[prior_key] = {} if @probabilities[prior_key].nil?
      next_chords.each do |next_chord, count|
        @probabilities[prior_key][next_chord] = 0 if @probabilities[prior_key][next_chord].nil?
        @probabilities[:priorless][next_chord] = 0 if @probabilities[:priorless][next_chord].nil?
        @probabilities[prior_key][next_chord] += count
        @probabilities[:priorless][next_chord] += count
      end
    end

    # normalize
    overall_total = 0
    @probabilities.each_key do |prior_key|
      next if prior_key == :priorless
      total = @probabilities[prior_key].values.inject(:+)
      @probabilities[prior_key].each_key do |next_key|
        @probabilities[prior_key][next_key] /= total.to_f
      end
      overall_total += total
    end

    @probabilities[:priorless].each_key do |key|
      @probabilities[:priorless][key] /= overall_total.to_f
    end
    
    @probabilities
  end

  # input: array of #(order) chord names
  def next_chord(chords)
    prior_key = chords.join(",")
    if @probabilities[prior_key].nil?
      random_chord @probabilities[:priorless]
    else
      random_chord @probabilities[prior_key]
    end
  end

  # input: seed- array of #(order) chord names
  #        count- number of chords to generate
  # output:
  #        array of #(count) chord names
  def compose(seed, count=10)
    song = []
    chords = seed.dup
    until count == 0
      chord = next_chord(chords)
      song << chord
      chords = chords[1..-1] + [chord]
      count -= 1
    end
    song
  end

  def save_model(fn)
    data = Marshal.dump(@occurrances)
    open(fn,'wb') do |f|
      f.puts data
    end
  end

  def load_model(fn)
    data = File.read(fn)
    @occurrances = Marshal.load(data)
  end

  private
  def random_chord(chord_prob)
    prob_array = []
    chord_array = []
    total = 0
    index = 0
    chord_prob.each_pair do |key, value|
      total += value
      prob_array[index] = total
      chord_array[index] = key
      index += 1
    end

    r = rand
    i = 0
    i += 1 until prob_array[i] > r

    chord_array[i]
  end
end
