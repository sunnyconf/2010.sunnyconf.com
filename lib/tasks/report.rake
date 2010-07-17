namespace :sunnyconf do

  def simple_format(text, html_options={})
    start_tag = tag('p', html_options, true)
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text.insert 0, start_tag
    text.html_safe.safe_concat("</p>")
  end

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
    #{simple_format(x.text)}
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