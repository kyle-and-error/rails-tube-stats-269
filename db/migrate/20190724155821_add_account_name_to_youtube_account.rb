class AddAccountNameToYoutubeAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :youtube_account, :name, :string
  end
end
