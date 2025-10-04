class AddPostableIdAndPostableTypeToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :postable_id, :integer, null: :false
    add_column :posts, :postable_type, :string, null: :false

    add_index :posts, :postable_id
  end
end
