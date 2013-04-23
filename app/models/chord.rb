class Chord < ActiveRecord::Base
  attr_accessible :file, :name

  def self.cached_find(id)
    @chords ||= []
    if @chords[id].nil?
      @chords[id] = self.find(id)
    end
    @chords[id]
  end

  def self.cached_find_by_name(name)
    @chord_names ||= {}
    if @chord_names[name].nil?
      @chord_names[name] = self.find_by_name(name)
    end
    @chord_names[name]
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
