require File.dirname(__FILE__) + '/../sunnyconf'
%w[ spec capybara capybara/dsl factory_girl factory_girl_extensions ].each {|lib| require lib }
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|file| require file }

DataMapper.setup :default, 'sqlite3::memory:'
DataMapper.auto_migrate!

Capybara.default_selector = :css
Capybara.app = Sinatra::Application

Spec::Runner.configure do |config|
  config.include Capybara
end
