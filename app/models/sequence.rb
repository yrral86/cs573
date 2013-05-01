class Sequence < ActiveRecord::Base
  attr_accessible :src, :seed_id
  has_many :chords, :order => 'position'
  belongs_to :seed, :class_name => 'Sequence'
  has_many :children, :class_name => 'Sequence', :foreign_key => 'seed_id'
  has_many :sequence_trials

  def ordered_chords
    @ordered_chords ||= ChordSequence.where(:sequence_id => self.id).order(:position).map do |cs|
      Chord.cached_find(cs.chord_id)
    end
    @ordered_chords
  end

  def to_csv
    ordered_chords.map{ |c| c.name }.join(",")
  end

  def percent_human
    p = 100*human_trial_count/trial_count unless trial_count == 0
    p = 'inf' unless p
    p
  end

  def human_trial_count
    human = (self.src.to_sym == :human)
    self.sequence_trials.where(:correct => human).count
  end

  def trial_count
    self.sequence_trials.count
  end

  def self.random_id
    query = nil
    if rand < 0.5
      query = self.where(:src => :human)
    else
      query = self.where("src != 'human' and src != 'seed'")
    end
    offset = rand(query.count)
    query.first(:offset => offset).id
  end

  def self.new_from_csv(csv, src, seed=nil)
    chords = csv.split(",")
    array = []
    chords.each do |chord_name|
      array << Chord.cached_find_by_name(chord_name).id
    end
    self.new_from_array(array, src, seed)
  end

  def self.new_from_params(params, src, seed=nil)
    array = []
    (1..4).to_a.each do |i|
      array << params[:sequence]["chord#{i}".to_sym]
    end
    self.new_from_array(array, src, seed)
  end

  # accepts an array of chord_ids
  def self.new_from_array(array, src, seed=nil)
    seed_id = nil
    seed_id = seed.id unless seed.nil?
    s = self.create(:src => src, :seed_id => seed_id)
    position = 1
    array.each do |chord_id|
      ChordSequence.create(:chord_id => chord_id,
                           :sequence_id => s.id,
                           :position => position)
      position += 1
    end
    s
  end

  def self.find_duplicates
    all = self.all
    seen = Hash.new
    all.each do |s|
      csv = s.to_csv
      seen[csv] = [] if seen[csv].nil?
      seen[csv] << s
    end

    seen.each_pair do |k, v|
      if v.size > 1
        puts "Duplicates detected for csv #{k}:"
        v.each do |s|
          puts s.inspect
        end
      end
    end
  end
end
