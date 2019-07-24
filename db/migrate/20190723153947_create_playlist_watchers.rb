class CreatePlaylistWatchers < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_watchers do |t|
      t.references :playlist, foreign_key: true

      t.timestamps
    end
    add_reference :playlist_watchers, :watcher, foreign_key: { to_table: :youtube_accounts }
  end
end
