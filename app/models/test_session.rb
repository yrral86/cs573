class TestSession < ActiveRecord::Base
  attr_accessible :end_time, :ip, :referer, :start_time, :user_agent

  def self.new_from_details(details)
    self.create(details)
  end
end
