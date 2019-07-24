class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.text :message
      t.references :playlist, foreign_key: true
      t.references :video, foreign_key: true
      t.references :creator, foreign_key: true

      t.timestamps
    end
    add_reference :suggestions, :watcher, foreign_key: { to_table: :youtube_accounts }
  end
end
