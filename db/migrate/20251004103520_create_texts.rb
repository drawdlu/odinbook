class CreateTexts < ActiveRecord::Migration[8.0]
  def change
    create_table :texts do |t|
      t.string :body, null: :false

      t.timestamps
    end
  end
end
