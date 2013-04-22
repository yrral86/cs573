class ComposeController < ApplicationController
  def index
  end

  def j48
    if params[:sequence]
      s = Sequence.new_from_params(params, "seed")
      redirect_to s
    else
      @chord_options = Chord.all_options
    end
  end

  def randomforests
  end

  def markov
  end
end
