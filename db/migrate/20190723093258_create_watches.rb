class CreateWatches < ActiveRecord::Migration[5.2]
  def change
    create_table :watches do |t|
      t.boolean :subscription

      t.timestamps
    end
    add_reference :watches, :watcher, foreign_key: { to_table: :youtube_accounts }
    add_reference :watches, :creator, foreign_key: { to_table: :youtube_accounts }
  end
end
