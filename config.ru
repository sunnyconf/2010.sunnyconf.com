require 'sunnyconf'

dev_db = "sqlite3://#{ File.expand_path(File.dirname(__FILE__) + '/sunnyconf.sqlite3') }"
DataMapper.setup :default, ENV['DATABASE_URL'] || dev_db
DataMapper.auto_upgrade!

run SunnyConf.new
