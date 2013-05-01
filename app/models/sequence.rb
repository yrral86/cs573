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

  def self.print_duplicates
    seen = self.find_duplicates

    seen.each_pair do |k, v|
      if v.size > 1
        puts "Duplicates detected for csv #{k}:"
        v.each do |s|
          puts s.inspect
        end
      end
    end
  end

  # removes learner generated sequences that are
  # duplicates of data seen
  # also removes duplication from human sequences
  def self.remove_reproductions
    seen = self.find_duplicates

    seen.each_pair do |csv, seqs|
      human = seqs.select{|s| s.src.to_sym == :human}
      if human.size > 0
        primary = human[0]
        seqs.each do |s|
          self.fold_into(primary, s)
        end
      end
    end
  end

  def self.remove_same_src_duplicates
    seen = self.find_duplicates
    seen.each_pair do |csv, seqs|
      while seqs.size > 0
        primary = seqs[0]
        matches = seqs.select{|s| s.src == primary.src}
        matches.each do |s|
          self.fold_into(primary, s)
          seqs.delete(s)
        end
      end
    end
  end

  private
  def self.find_duplicates
    all = self.all
    seen = Hash.new
    all.each do |s|
      csv = s.to_csv
      seen[csv] = [] if seen[csv].nil?
      seen[csv] << s
    end
    seen.select do |csv, seq|
      seq.size > 1
    end
  end

  def self.fold_into(target, duplicate)
    puts "folding id #{duplicate.id} into #{target.id}"
    unless duplicate.id == target.id
      SequenceTrial.where(:sequence_id => duplicate.id).update_all(:sequence_id => target.id)
      ChordSequence.where(:sequence_id => duplicate.id).destroy_all
      duplicate.destroy
    end
  end
end
