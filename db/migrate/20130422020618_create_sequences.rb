class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.text :src

      t.timestamps
    end
  end
end
