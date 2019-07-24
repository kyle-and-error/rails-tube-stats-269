class CreateWatchedVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :watched_videos do |t|
      t.integer :like_status, default: 0
      t.references :video, foreign_key: true
      t.references :watch, foreign_key: true
      t.datetime :datetime_watched, null: false

      t.timestamps
    end
  end
end
