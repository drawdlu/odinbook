class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.text :image
      t.text :about
      t.text :fist_name
      t.text :last_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
