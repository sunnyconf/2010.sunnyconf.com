desc 'Captures a heroku bundle and downloads it.  The downloaded files are stored in backups/'
task :backup do
  require 'time'
  appname = ENV["APPNAME"] || "sunnyconf"

  timestamp = Time.now.strftime("%Y-%m-%d-%H%M")
  bundle_name = "#{appname}-#{timestamp}"

  puts "Capturing bundle #{bundle_name}..."
  `heroku bundles:capture --app #{appname} '#{bundle_name}'`

  # poll for completion (warning, a little hacky)
  begin
    bundles = `heroku bundles --app #{appname}`
  end while bundles.match(/complete/).nil?
  
  # download & destroy the bundle we just captured
  %w(download destroy).each do | action |
    `heroku bundles:#{action} --app #{appname} '#{bundle_name}'`
  end
  
  `mv #{appname}.tar.gz backups/#{bundle_name}.tar.gz`
  puts "Bundle captured and stored in backups/#{bundle_name}.tar.gz"
end