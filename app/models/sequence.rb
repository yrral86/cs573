class Sequence < ActiveRecord::Base
  attr_accessible :src, :seed_id
  has_many :chords, :order => 'position'
  belongs_to :seed, :class_name => 'Sequence'
  has_many :children, :class_name => 'Sequence', :foreign_key => 'seed_id'

  def ordered_chords
    @ordered_chords ||= ChordSequence.where(:sequence_id => self.id).order(:position).map do |cs|
      Chord.cached_find(cs.chord_id)
    end
    @ordered_chords
  end

  def to_csv
    ordered_chords.map{ |c| c.name }.join(",")
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
    (1..3).to_a.each do |i|
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
end
