class Proposal
  include DataMapper::Resource

  property :id,    Serial
  property :name,  String, :required => true, :length => 255
  property :email, String, :required => true, :length => 255, :format => :email_address
  property :text,  Text,   :required => true

  def email_with_name
    "#{name} <#{email}>"
  end

end
