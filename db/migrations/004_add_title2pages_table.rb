# 004_add_title2pages_table
require_relative '../../environment'

class AddTitle2PagesTable < ActiveRecord::Migration
  def up
    add_column :pages, :title, :string
    puts 'ran up method'
  end

  def down
    remove_column :pages, :title
    puts 'ran down method'
  end
end

AddTitle2PagesTable.migrate(:up)
