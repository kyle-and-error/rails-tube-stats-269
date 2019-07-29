class RemoveColumnsFromYoutubeAccountsAndChannels < ActiveRecord::Migration[5.2]
  def change
    remove_column :youtube_accounts, :url
    remove_column :creators, :url
  end
end
