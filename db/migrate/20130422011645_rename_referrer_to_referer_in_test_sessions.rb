class RenameReferrerToRefererInTestSessions < ActiveRecord::Migration
  def up
    rename_column :test_sessions, :referrer, :referer
  end

  def down
    rename_column :test_sessions, :referer, :referrer
  end
end
