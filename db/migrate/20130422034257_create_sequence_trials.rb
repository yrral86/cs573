class CreateSequenceTrials < ActiveRecord::Migration
  def change
    create_table :sequence_trials do |t|
      t.integer :sequence_id
      t.integer :test_session_id
      t.boolean :correct

      t.timestamps
    end
  end
end
