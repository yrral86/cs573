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
    (1..10).to_a.each do |position|
      chord = Chord.find_by_name(chords[position-1])
      ChordSequence.create(:chord_id => chord.id,
                           :sequence_id => s.id,
                           :position => position)
    end
    s
  end
end
