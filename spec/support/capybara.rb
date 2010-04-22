$sunny_conf = SunnyConf.new

# It is useful to have access to the actual 
# instance of SunnyConf that we're running against.
def sunny_conf_instance
  instance = $sunny_conf
  while not instance.is_a?(SunnyConf)
    instance = instance.instance_variable_get('@app')
    break if instance.nil?
  end
  instance
end

Capybara.default_selector = :css
Capybara.app = $sunny_conf

# fill_in_fields :foo => 'bar'
# fill_in_fields :user, :foo => 'bar'
# fill_in_fields :user, :stuff, :foo => 'bar'
def fill_in_fields prefix, hash_of_fields
  hash_of_fields.each do |field_name, field_value|
    fill_in "#{prefix}[#{field_name}]", :with => field_value
  end
end
