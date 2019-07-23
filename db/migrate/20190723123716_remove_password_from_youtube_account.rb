class RemovePasswordFromYoutubeAccount < ActiveRecord::Migration[5.2]
  def change
    remove_column :youtube_accounts, :password

  end
end
