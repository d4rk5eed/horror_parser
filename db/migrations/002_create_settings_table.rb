# 002_create_settings_table
require_relative '../../environment'

class CreateSettingsTable < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.datetime :last_article_time

      t.timestamps
    end
    puts 'ran up method'
  end

  def down
    drop_table :settings
    puts 'ran down method'
  end
end

CreateSettingsTable.migrate(:up)
Setting.create(last_article_time: DateTime.parse('2016-05-21T00:09:23+03:00'))
