class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
    add_reference :playlists, :creator, foreign_key: { to_table: :youtube_accounts }
  end
end
