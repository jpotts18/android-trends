# require 'bundler' 

require 'active_record'
require 'sidekiq'
require './db/models'
require './worker'

puts 'Loading configs...'

ActiveRecord::Base.logger = Logger.new('debug.log')
config = YAML::load(IO.read('config/database.yml'))

puts 'Connecting to DB....'
ActiveRecord::Base.establish_connection(config['development'])