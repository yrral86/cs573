class SequenceTrial < ActiveRecord::Base
  attr_accessible :correct, :sequence_id, :test_session_id
  belongs_to :sequence
  belongs_to :test_session
end
