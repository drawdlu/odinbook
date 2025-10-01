class RenameFistNameToFirstNameOnProfiles < ActiveRecord::Migration[8.0]
  def change
    rename_column :profiles, :fist_name, :first_name
  end
end
