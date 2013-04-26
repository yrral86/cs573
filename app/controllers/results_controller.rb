class ResultsController < ApplicationController
  def index
    @all_trials = SequenceTrial.completed_trials
    @human_trials = SequenceTrial.human_trials
    @correct_human_trials = SequenceTrial.correct_human_trials
    @incorrect_human_trials = SequenceTrial.incorrect_human_trials
    @computer_trials = SequenceTrial.computer_trials
    @correct_computer_trials = SequenceTrial.correct_computer_trials
    @incorrect_computer_trials = SequenceTrial.incorrect_computer_trials
  end
end
