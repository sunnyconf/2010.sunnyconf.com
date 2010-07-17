namespace :sunnyconf do

  task :environment do
    require 'sunnyconf'
    DataMapper.setup :default, ENV['DATABASE_URL']
  end

  desc "Dump reports"
  task :reports => :environment do
    header =<<HTML
<html>
<head><title>SunnyConf Proposals</title></head>
<body>
HTML
    puts header
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
    footer =<<HTML
</body>
</html>
HTML
  puts footer
  end
  
  desc "Dump JSON"
  task :reports_json => :environment do
    puts Proposal.all.to_json
  end
  
end