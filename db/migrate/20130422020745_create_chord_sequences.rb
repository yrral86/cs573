class CreateChordSequences < ActiveRecord::Migration
  def change
    create_table :chord_sequences do |t|
      t.integer :chord_id
      t.integer :sequence_id
      t.integer :position

      t.timestamps
    end
  end
end
