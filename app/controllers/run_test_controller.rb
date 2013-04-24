class RunTestController < ApplicationController
  def index
  end

  def start
    @test_session.start_time = Time.now
    @test_session.save
    redirect_to :action => :next
  end

  def next
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
      else
        flash[:notice] = "Please select human or computer"
        session[:sequence_trial_id] = @trial.id
      end
      redirect_to :action => :next
    else
      if @test_session.sequence_trials.size < 10
        if flash[:notice]
          @trial = SequenceTrial.find(session[:sequence_trial_id])
        else
          @trial = SequenceTrial.new(:test_session_id => @test_session.id,
                                     :sequence_id => Sequence.random_id)
          @trial.save
        end
      else
        redirect_to :action => :finish
      end
    end
  end

  def finish
    @test_session.end_time = Time.now
    @test_session.save
    reset_session
  end
end
