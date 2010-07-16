namespace :sunnyconf do

  desc "Dump reports"
  task :reports => :environment do
    puts Proposal.count
  end
  
end