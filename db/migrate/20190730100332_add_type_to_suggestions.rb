class AddTypeToSuggestions < ActiveRecord::Migration[5.2]
  def change
    add_column :suggestions, :type, :string
    add_column :suggestions, :action, :string
  end
end
