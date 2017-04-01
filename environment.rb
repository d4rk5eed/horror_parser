# environment.rb
# recursively requires all files in ./lib and down that end in .rb
require 'active_record'
require 'nokogiri'
require 'database_cleaner'

Dir.glob('./lib/*.rb').each do |file|
  require file
end

Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder + "/*.rb").each do |file|
    require file
  end
end

ENV['APP_ENV'] ||= 'development'

$config = YAML.load_file("config/config.yml")[ENV['APP_ENV']].symbolize_keys
db_config = YAML.load_file("config/database.yml")[ENV['APP_ENV']]
# tells AR what db file to use
ActiveRecord::Base.establish_connection(db_config)
$logger = Logger.new($config[:logger], 'daily')
$logger.level = $config[:logger_level]
