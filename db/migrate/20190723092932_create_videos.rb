class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :topic
      t.references :creator, foreign_key: true

      t.timestamps
    end
  end
end
