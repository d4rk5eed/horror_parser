#005_add_unique_index_column
require_relative '../../environment'

class AddUniqueIndexColumn < ActiveRecord::Migration
  def up
    add_index(:users, :chat_id, { unique: true })
  end

  def down
    remove_index(:users, column: :chat_id)
  end
end

AddUniqueIndexColumn.migrate(:up)
