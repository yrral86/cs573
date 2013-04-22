class CreateChords < ActiveRecord::Migration
  def change
    create_table :chords do |t|
      t.text :name
      t.text :file

      t.timestamps
    end
  end
end
