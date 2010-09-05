# Arkayne Rake Helper
#
# For interactive debugging and testing purposes
namespace :arkayne do
  include ArkayneApiHelper

  def arkayne_profile_token
    apt = ark_load_config(RAILS_ENV)["arkayne_profile_token"]
    raise "Couldn't find ENV['ARKAYNE_PROFILE_TOKEN']" unless apt
    apt
  end

  # Usage
  #   ARKAYNE_PROFILE_TOKEN=2010-THizMyKey URL=http://foo.com/blah.html rake arkayne:recos_for_url
  desc "Prints Arkayne recommendations for ENV['URL'] to STDOUT"
  task :recos_for_url => :environment do
    puts arkayne_recommendations_for(ENV['URL'], arkayne_profile_token)
  end

end
