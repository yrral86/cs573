class Sequence < ActiveRecord::Base
  attr_accessible :src
  has_many :chords, :order => 'position'

  def ordered_chords
    @ordered_chords ||= ChordSequence.where(:sequence_id => self.id).order(:position).map do |cs|
      Chord.cached_find(cs.chord_id)
    end
    @ordered_chords
  end

  def self.new_from_csv(csv, src)
    s = self.create(:src => src)
    chords = csv.split(",")
    array = []
    chords.each do |chord_name|
      array << Chord.cached_find_by_name(chord_name).id
    end
    self.new_from_array(array,src)
  end

  def self.new_from_params(params, src)
    array = []
    (1..3).to_a.each do |i|
      array << params[:sequence]["chord#{i}".to_sym]
    end
    self.new_from_array(array, src)
  end

  # accepts an array of chord_ids
  def self.new_from_array(array, src)
    s = self.create(:src => src)
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
