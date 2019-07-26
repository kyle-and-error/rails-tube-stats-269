class AddColumnsToCreators < ActiveRecord::Migration[5.2]
  def change
    add_column :creators, :title, :string
    add_column :creators, :description, :text
    add_column :creators, :thumbnail, :text
    add_column :creators, :subscribers, :integer
  end
end
