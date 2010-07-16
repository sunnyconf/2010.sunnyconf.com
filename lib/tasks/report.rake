namespace :sunnyconf do

  task :environment do
    require 'sunnyconf'
  end

  desc "Dump reports"
  task :reports => :environment do
    require 'pp'
    pp Proposal.all
  end
  
end