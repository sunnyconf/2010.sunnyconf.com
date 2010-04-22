# fill_in_fields :foo => 'bar'
# fill_in_fields :user, :foo => 'bar'
# fill_in_fields :user, :stuff, :foo => 'bar'
def fill_in_fields prefix, hash_of_fields
  hash_of_fields.each do |field_name, field_value|
    fill_in "#{prefix}[#{field_name}]", :with => field_value
  end
end
