class CreatePockets < ActiveRecord::Migration[8.1]
  def change
    create_table :pockets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :icon
      t.string :color

      t.timestamps
    end
  end
end
