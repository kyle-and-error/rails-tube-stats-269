class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :topic

      t.timestamps
    end
    add_reference :videos, :creator, foreign_key: { to_table: :youtube_accounts }
  end
end
