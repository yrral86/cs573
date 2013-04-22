class CreateTestSessions < ActiveRecord::Migration
  def change
    create_table :test_sessions do |t|
      t.text :user_agent
      t.text :ip
      t.text :referrer
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
