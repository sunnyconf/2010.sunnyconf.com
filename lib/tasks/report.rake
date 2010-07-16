namespace :sunnyconf do

  desc "Dump reports"
  task :reports do
    puts Proposal.count
  end
  
end