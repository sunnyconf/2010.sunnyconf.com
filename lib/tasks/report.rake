namespace :sunnyconf do

  task :environment do
    require 'sunnyconf'
    DataMapper.setup :default, ENV['DATABASE_URL']
  end

  desc "Dump reports"
  task :reports => :environment do
    Proposal.all.each do |x|
      html =<<HTML
<p>
  <strong>#{x.name} (#{x.email})</strong>
</p>
<p>
  #{x.text}
</p>
HTML
      puts html
    end
  end
  
end