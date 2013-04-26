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

  def self.human_trials
    self.select_humans(self.completed_trials)
  end

  def self.correct_human_trials
    self.select_humans(self.correct_trials)
  end

  def self.incorrect_human_trials
    self.select_humans(self.incorrect_trials)
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

  def self.j48_trials
    self.select_model(self.completed_trials, :j48)
  end

  def self.correct_j48_trials
    self.select_model(self.correct_trials, :j48)
  end

  def self.incorrect_j48_trials
    self.select_model(self.incorrect_trials, :j48)
  end

  def self.randomforests_trials
    self.select_model(self.completed_trials, :randomforests)
  end

  def self.correct_randomforests_trials
    self.select_model(self.correct_trials, :randomforests)
  end

  def self.incorrect_randomforests_trials
    self.select_model(self.incorrect_trials, :randomforests)
  end

  def self.oner_trials
    self.select_model(self.completed_trials, :oner)
  end

  def self.correct_oner_trials
    self.select_model(self.correct_trials, :oner)
  end

  def self.incorrect_oner_trials
    self.select_model(self.incorrect_trials, :oner)
  end

  def self.markov_trials
    self.select_model(self.completed_trials, :markov)
  end

  def self.correct_markov_trials
    self.select_model(self.correct_trials, :markov)
  end

  def self.incorrect_markov_trials
    self.select_model(self.incorrect_trials, :markov)
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

  def self.select_model(query, model)
    query.select do |t|
      t.sequence.src.to_sym == model
    end
  end
end
