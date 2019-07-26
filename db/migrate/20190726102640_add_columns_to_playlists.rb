class AddColumnsToPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :youtube_id, :string
    add_column :playlists, :description, :text
    add_column :playlists, :thumbnail, :text
  end
end
