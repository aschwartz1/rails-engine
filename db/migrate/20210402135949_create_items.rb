class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :merchant, foreign_key: true
      t.string :name
      t.string :description
      t.decimal :unit_price, precision: 5, scale: 2
      t.timestamps
    end
  end
end
