# 003_create_userss_table
require_relative '../../environment'

class CreateUsersTable < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :chat_id
      t.boolean :active
      t.datetime :last_touch
      t.text :tags, array: true, default: []

      t.timestamps
    end
    puts 'ran up method'
  end

  def down
    drop_table :users
    puts 'ran down method'
  end
end

CreateUsersTable.migrate(:up)
