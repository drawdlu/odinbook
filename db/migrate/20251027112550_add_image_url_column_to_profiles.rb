class AddImageUrlColumnToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :image_url, :string
  end
end
