class RenameTypeInSuggestionToKind < ActiveRecord::Migration[5.2]
  def change
    rename_column :suggestions, :type, :kind
  end
end
