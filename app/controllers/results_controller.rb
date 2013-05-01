class ResultsController < ApplicationController
  def index
    @all_trials = SequenceTrial.completed_trials
    @human_trials = SequenceTrial.human_trials
    @correct_human_trials = SequenceTrial.correct_human_trials
    @incorrect_human_trials = SequenceTrial.incorrect_human_trials
    @computer_trials = SequenceTrial.computer_trials
    @correct_computer_trials = SequenceTrial.correct_computer_trials
    @incorrect_computer_trials = SequenceTrial.incorrect_computer_trials
    @j48_trials = SequenceTrial.j48_trials
    @correct_j48_trials = SequenceTrial.correct_j48_trials
    @incorrect_j48_trials = SequenceTrial.incorrect_j48_trials
    @randomforests_trials = SequenceTrial.randomforests_trials
    @correct_randomforests_trials = SequenceTrial.correct_randomforests_trials
    @incorrect_randomforests_trials = SequenceTrial.incorrect_randomforests_trials
    @oner_trials = SequenceTrial.oner_trials
    @correct_oner_trials = SequenceTrial.correct_oner_trials
    @incorrect_oner_trials = SequenceTrial.incorrect_oner_trials
    @markov_trials = SequenceTrial.markov_trials
    @correct_markov_trials = SequenceTrial.correct_markov_trials
    @incorrect_markov_trials = SequenceTrial.incorrect_markov_trials
  end

  def test
    where = SequenceTrial.where(:test_session_id => @test_session.id)
    @all_trials = where.completed_trials
    @human_trials = where.human_trials
    @correct_human_trials = where.correct_human_trials
    @incorrect_human_trials = where.incorrect_human_trials
    @computer_trials = where.computer_trials
    @correct_computer_trials = where.correct_computer_trials
    @incorrect_computer_trials = where.incorrect_computer_trials
  end

  def details
    @trials = nil
    case params[:method].to_sym
    when :markov
      @trials = SequenceTrial.markov_trials
    when :j48
      @trials = SequenceTrial.j48_trials
    when :oner
      @trials = SequenceTrial.oner_trials
    when :randomforests
      @trials = SequenceTrial.randomforests_trials
    else
      redirect_to request.referer
    end
    @good_sequences = @trials.where(:correct => false).group(:sequence_id).select('sequence_trials.*, count(sequence_id) as trials').order("trials DESC").limit(10)
    @bad_sequences = @trials.where(:correct => true).group(:sequence_id).select('sequence_trials.*, count(sequence_id) as trials').order("trials ASC").limit(10)
  end
end
