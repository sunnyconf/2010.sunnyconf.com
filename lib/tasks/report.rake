namespace :sunnyconf do

  task :environment do
    require 'sunnyconf'
    DataMapper.setup :default, ENV['DATABASE_URL']
  end

  desc "Dump reports"
  task :reports => :environment do
    require 'pp'
    pp Proposal.all
  end
  
end