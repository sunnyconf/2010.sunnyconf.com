require 'rubygems'
require 'sinatra'

helpers do
  
  def link text, href
    %{<a href="#{ href }">#{ text }</a>}
  end

end

get '/' do
  haml :index
end
