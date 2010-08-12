namespace :sunnyconf do

  def simple_format(text)
    start_tag = "<p>"
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text << "</p>"
  end

  task :environment do
    require 'sunnyconf'
    DataMapper.setup :default, ENV['DATABASE_URL']
  end

  # Run on heroku via heroku rake sunnyconf:reports
  desc "Dump reports"
  task :reports => :environment do
    header =<<HTML
<html>
<head><title>SunnyConf Proposals</title></head>
<body>
<ol>
HTML
    puts header
    Proposal.all.each do |x|
      next if [1,2,3].include?(x.id)
      html =<<HTML
<p>
  <li><strong>"#{x.name}" &lt;#{x.email}&gt;</strong></li>
</p>
<p>
    #{simple_format(x.text)}
</p>
HTML
      puts html
    end
    footer =<<HTML
</ol>
</body>
</html>
HTML
  puts footer
  end
  
  desc "Dump JSON"
  task :reports_json => :environment do
    puts Proposal.all.to_json
  end

  desc "Dump emails"
  task :reports_email => :environment do
    Proposal.all.each do |e|
      puts "\"#{x.name}\" &lt;#{x.email}&gt;"
    end
  end
  
end
