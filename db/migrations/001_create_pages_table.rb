#001_create_pages_table
require_relative '../../environment'

class CreatePagesTable < ActiveRecord::Migration
  def up
    create_table :pages do |t|
      t.string :url
      t.text :body
      t.text :tags, array: true, default: []

      t.timestamps
    end
    puts 'ran up method'
  end

  def down
    drop_table :pages
    puts 'ran down method'
  end
end

CreatePagesTable.migrate(:up)
