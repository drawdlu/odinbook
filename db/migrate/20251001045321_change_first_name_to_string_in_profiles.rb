class ChangeFirstNameToStringInProfiles < ActiveRecord::Migration[8.0]
  def change
    change_column :profiles, :fist_name, :string
    change_column :profiles, :last_name, :string
  end
end
