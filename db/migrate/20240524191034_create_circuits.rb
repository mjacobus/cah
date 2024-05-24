class CreateCircuits < ActiveRecord::Migration[7.1]
  def change
    create_table :circuits do |t|
      t.string :name
      t.string :overseer_name
      t.string :overseer_phone_number

      t.timestamps
    end
    add_index :circuits, :name, unique: true
  end
end
