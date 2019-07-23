class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :video, foreign_key: true
      t.text :text

      t.timestamps
    end
    add_reference :comments, :watcher, foreign_key: { to_table: :youtube_accounts }
  end
end
