class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :youtube_id
      t.string :topic
      t.text :thumbnail
      t.references :creator, foreign_key: true

      t.timestamps
    end
  end
end
