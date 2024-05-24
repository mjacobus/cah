class CreateCongregations < ActiveRecord::Migration[7.1]
  def change
    create_table :congregations do |t|
      t.string :name
      t.string :number
      t.string :contact_person_name
      t.string :contact_person_phone_number
      t.string :city_name
      t.string :address
      t.references :circuit

      t.timestamps
    end
    add_index :congregations, :number, unique: true
    add_index :congregations, %i[name circuit_id], unique: true
  end
end
