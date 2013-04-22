class AddSeedIdToSequence < ActiveRecord::Migration
  def change
    add_column :sequences, :seed_id, :integer
  end
end
