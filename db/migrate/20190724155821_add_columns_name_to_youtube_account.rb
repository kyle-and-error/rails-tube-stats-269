class AddColumnsToYoutubeAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :youtube_account, :name, :string
    add_column :youtube_account, :code, :string
  end
end
