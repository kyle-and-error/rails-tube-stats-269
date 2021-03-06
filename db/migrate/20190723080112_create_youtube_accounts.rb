class CreateYoutubeAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :youtube_accounts do |t|
      t.string :email
      t.string :url
      t.string :youtube_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
