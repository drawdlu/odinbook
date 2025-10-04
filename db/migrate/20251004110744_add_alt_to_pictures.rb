class AddAltToPictures < ActiveRecord::Migration[8.0]
  def change
    add_column :pictures, :alt, :string
  end
end
