class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :householder_name
      t.string :phone_number
      t.string :street_name
      t.string :number
      t.string :complement
      t.string :postal_code
      t.string :neighborhood
      t.string :city_name
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.references :congregation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
