class SequenceTrial < ActiveRecord::Base
  attr_accessible :correct, :sequence_id, :test_session_id
  belongs_to :sequence
  belongs_to :test_session

  def self.completed_trials
    self.where("correct IS NOT NULL")
  end

  def self.correct_trials
    self.where(:correct => true)
  end

  def self.incorrect_trials
    self.where(:correct => false)
  end

  def self.computer_trials
    self.select_computers(self.completed_trials)
  end

  def self.correct_computer_trials
    self.select_computers(self.correct_trials)
  end

  def self.incorrect_computer_trials
    self.select_computers(self.incorrect_trials)
  end

  def self.human_trials
    self.select_humans(self.completed_trials)
  end

  def self.correct_human_trials
    self.select_humans(self.correct_trials)
  end

  def self.incorrect_human_trials
    self.select_humans(self.incorrect_trials)
  end

  private
  def self.select_humans(query)
    query.select do |t|
      t.sequence.src.to_sym == :human
    end
  end

  def self.select_computers(query)
    query.select do |t|
      t.sequence.src.to_sym != :human and
        t.sequence.src.to_sym != :seed
    end
  end
end
