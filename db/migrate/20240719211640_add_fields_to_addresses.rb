class AddFieldsToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :assignee_notes, :text
    add_column :addresses, :expected_start_date, :datetime
    add_column :addresses, :expected_finish_date, :datetime
    add_column :addresses, :code, :string

    add_index :addresses, :code, unique: true
  end
end
