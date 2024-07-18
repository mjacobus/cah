class RemoveResolvedColumnFromAddresses < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      UPDATE addresses
      SET stage = 2
      WHERE resolved = true;
    SQL

    remove_column :addresses, :resolved
  end

  def down
    add_column :addresses, :resolved, :boolean, default: false, null: false

    execute <<~SQL
      UPDATE addresses
      SET resolved = true
      WHERE stage = 2;
    SQL
  end
end
