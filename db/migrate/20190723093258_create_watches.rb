class CreateWatches < ActiveRecord::Migration[5.2]
  def change
    create_table :watches do |t|
      t.boolean :subscription
      t.references :creator, foreign_key: true

      t.timestamps
    end
    add_reference :watches, :watcher, foreign_key: { to_table: :youtube_accounts }
  end
end
