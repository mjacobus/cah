class AddStageToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :stage, :integer, default: 0, null: false
    add_index :addresses, :stage
  end
end
