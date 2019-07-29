class AddColumnsToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :length, :integer
  end
end
