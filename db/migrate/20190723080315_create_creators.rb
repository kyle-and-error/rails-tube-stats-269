class CreateCreators < ActiveRecord::Migration[5.2]
  def change
    create_table :creators do |t|
      t.string :url
      t.string :youtube_id
      t.timestamps
    end
  end
end
