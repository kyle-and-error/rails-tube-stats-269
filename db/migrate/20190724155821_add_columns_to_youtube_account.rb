class AddColumnsToYoutubeAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :youtube_accounts, :name, :string
    add_column :youtube_accounts, :username, :string
    add_column :youtube_accounts, :code, :string
    add_column :youtube_accounts, :avatar, :string
    add_column :youtube_accounts, :location, :string
  end
end
