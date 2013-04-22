class Chord < ActiveRecord::Base
  attr_accessible :file, :name

  def self.cached_find(id)
    @chords ||= []
    if @chords[id].nil?
      @chords[id] = Chord.find(id)
    end
    @chords[id]
  end
end
