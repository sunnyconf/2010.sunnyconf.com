require File.dirname(__FILE__) + '/../sunnyconf'
%w[ spec capybara capybara/dsl factory_girl factory_girl_extensions ].each {|lib| require lib }
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].sort.each                 {|lib| require lib }

DataMapper.setup :default, 'sqlite3::memory:'
DataMapper.auto_migrate!

Spec::Runner.configure do |config|
  config.include Capybara
end

