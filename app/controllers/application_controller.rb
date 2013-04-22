class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :ensure_test_session

  private
  def ensure_test_session
    if session[:test_session_id].nil?
      details = {
        :user_agent => request.env["HTTP_USER_AGENT"],
        :ip => request.remote_ip,
        :referer => request.env["HTTP_REFERER"]
      }
      @test_session = TestSession.new_from_details(details)
      session[:test_session_id] = @test_session.id
    end
    test_session
  end

  def test_session
    @test_session ||= TestSession.find(session[:test_session_id])
    @test_session
  end
end
