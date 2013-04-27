class RunTestController < ApplicationController
  def index
  end

  def start
    @test_session.start_time = Time.now
    @test_session.save
    redirect_to :action => :next
  end

  def next
    logger.debug("in next, params=#{params.inspect}, session=#{session.inspect}")
    if params[:sequence]
      @trial = SequenceTrial.where(:test_session_id => @test_session.id,
                                   :sequence_id => params[:sequence][:id]).first
      if params[:sequence][:src]
        if @trial.sequence.src.to_sym == :human
          if params[:sequence][:src].to_sym == :human
            @trial.correct = true
          else
            @trial.correct = false
          end
        else
          if params[:sequence][:src].to_sym == :computer
            @trial.correct = true
          else
            @trial.correct = false
          end
        end
        @trial.save
        session[:sequence_trial_id] = nil
      else
        flash[:notice] = "Please select human or computer"
      end
      redirect_to :action => :next
    else
      @trial_count = @test_session.sequence_trials.where("correct IS NOT NULL").size
      if @trial_count < 10
        logger.debug ("stid: #{session[:sequence_trial_id]}, stid2: #{session['sequence_trial_id']}")
        if session[:sequence_trial_id].nil?
          @trial = SequenceTrial.new(:test_session_id => @test_session.id,
                                     :sequence_id => Sequence.random_id)
          @trial.save
          session[:sequence_trial_id] = @trial.id
        else
          @trial = SequenceTrial.find(session[:sequence_trial_id])
        end
      else
        redirect_to :action => :finish
      end
    end
  end

  def finish
    @test_session.end_time = Time.now
    @test_session.save
    redirect_to :controller => :results, :action => :test
  end

  def reset
    reset_session
    redirect_to :action => :index
  end
end
