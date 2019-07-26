class AddColumnsToYoutubeAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :youtube_accounts, :name, :string
    add_column :youtube_accounts, :username, :string
    add_column :youtube_accounts, :refresh_token, :string
    add_column :youtube_accounts, :avatar, :text
    add_column :youtube_accounts, :location, :string
  end
end
