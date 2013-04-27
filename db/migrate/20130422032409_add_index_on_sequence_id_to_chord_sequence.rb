class AddIndexOnSequenceIdToChordSequence < ActiveRecord::Migration
  def change
    change_table :chord_sequences do |t|
      t.index :sequence_id
    end
  end
end
