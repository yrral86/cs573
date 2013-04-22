class Chord < ActiveRecord::Base
  attr_accessible :file, :name

  def self.cached_find(id)
    @chords ||= []
    if @chords[id].nil?
      @chords[id] = Chord.find(id)
    end
    @chords[id]
  end

  def self.cached_find_by_name(name)
    @chord_names ||= []
    if @chords[name].nil?
      @chords[name] = Chord.find_by_name(name)
    end
    @chords[name]
  end

  def self.all_options
    chords = self.all
    options = []
    chords.each do |chord|
      options << [chord.name, chord.id]
    end
    options
  end
end
