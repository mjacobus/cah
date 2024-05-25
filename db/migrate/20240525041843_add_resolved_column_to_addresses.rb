class AddResolvedColumnToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :resolved, :boolean, default: false, null: false
  end
end
