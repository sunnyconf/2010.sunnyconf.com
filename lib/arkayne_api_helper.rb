# Arkayne API helper module
#
# For example:
#
#   ark_recommendations_for("Pksk-7285-sekr3t-k3y", "http://example.com/2010/02/29/arkayne-api-is-best")
#   # => <a String containing recommendations, in HTML>
#
module ArkayneApiHelper

  SITE_URL = "http://www.arkayne.com/plugin"
  SECURE_SITE_URL = "https://www.arkayne.com/plugin/secure"

  # Issues a call to the Arkayne API
  # 
  # arkayne_profile_token - Provided by Arkayne.com.
  # full_url - Fully qualified URL, i.e. http://example.com/2010/02/29/arkayne-api-is-best
  #
  # Returns an HTML String
  def arkayne_recommendations_for(full_url, arkayne_profile_token = default_arkayne_profile_token)
    url_to_fetch = "#{SITE_URL}/#{arkayne_profile_token}/rails/?url=#{full_url}"
    Net::HTTP.get URI.parse(url_to_fetch)
  end
  
  # Read Arkayne Profile Token
  #
  # Returns a String
  def default_arkayne_profile_token
    ark_load_config(RAILS_ENV)["arkayne_profile_token"]
  end
  
  # Reads config/arkayne.yml and returns the arkayne_profile_token
  #
  # rails_env - Current Rails ENV variable, i.e. RAILS_ENV
  #
  # Returns a Hash containing the current profile configuration
  def ark_load_config(rails_env = RAILS_ENV)
    if @ark_profile_token.nil?
      file = Rails.root.join('config', 'arkayne.yml').to_s
      erbc = ERB.new(File.read(file)).result
      yaml = YAML.load(erbc)
      @ark_profile_token = yaml[rails_env]
    end
    @ark_profile_token
  end

end
