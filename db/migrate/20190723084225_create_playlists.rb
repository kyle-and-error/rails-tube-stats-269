class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :title
      t.string :url
      t.references :creator, foreign_key: true

      t.timestamps
    end
  end
end
