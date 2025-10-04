class ChangeBodyToContentOnTexts < ActiveRecord::Migration[8.0]
  def change
    rename_column :texts, :body, :content
  end
end
