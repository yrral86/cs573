class ComposeController < ApplicationController
  def index
  end

  def all
    if params[:sequence]
      s = compose_sequence(params, :all)
      redirect_to s
    else
      @chord_options = Chord.all_options
    end
  end

  def weka
    if params[:sequence]
      s = compose_sequence(params, :weka)
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
  def compose_sequence(params, method)
    s = Sequence.new_from_params(params, "seed")
    Composer.compose(s, method)
    s
  end
end
