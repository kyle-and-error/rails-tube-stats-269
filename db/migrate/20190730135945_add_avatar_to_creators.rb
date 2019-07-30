class AddAvatarToCreators < ActiveRecord::Migration[5.2]
  def change
    add_column :creators, :avatar, :text
  end
end
