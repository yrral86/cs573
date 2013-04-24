class ComposeController < ApplicationController
  def index
  end

  def j48
    if params[:sequence]
      s = compose_sequence(params, :j48)
      redirect_to s
    else
      @chord_options = Chord.all_options
    end
  end

  def randomforests
    if params[:sequence]
      s = compose_sequence(params, :randomforests)
      redirect_to s
    else
      @chord_options = Chord.all_options
    end
  end

  def markov
    if params[:sequence]
      s = compose_sequence(params, :markov)
      redirect_to s
    else
      @chord_options = Chord.all_options
    end
  end

  private
  def compose_sequence(params, model)
    s = Sequence.new_from_params(params, "seed")
    Composer.compose(s, model)
    s
  end
end
