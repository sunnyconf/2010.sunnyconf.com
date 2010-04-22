#! /usr/bin/env ruby
%w[ rubygems sinatra haml datamapper jadof rack/flash ].each {|lib| require lib }
Dir['lib/**/*.rb'].each                     {|lib| require lib }

use Rack::Session::Cookie
use Rack::Flash

helpers do
  def cache!
    headers['Cache-Control'] = 'public, max-age=300' if ENV['RACK_ENV'] == 'production'
  end

  def page name
    JADOF::Page[name].to_html
  end
end

# Static Pages
get '/' do
  cache!
  haml :index
end

get '/stylesheets/application.css' do
  cache!
  content_type 'text/css'
  sass :stylesheet
end

get '/*' do
  cache!
  @page = JADOF::Page.get params[:splat]
  if @page
    haml @page.to_html
  else
    status 404
  end
end

# Proposals
get '/proposals/new' do
  @proposal = Proposal.new
  haml :proposal
end

post '/proposals' do
  @proposal = Proposal.new params[:proposal]

  case params[:commit]
  when 'Preview Proposal'
    haml @proposal.valid? ? :proposal_preview : :proposal

  when 'Edit Proposal'
    haml :proposal

  when 'Submit Proposal'
    if @proposal.save
      flash[:notice] = 'Thank you for your proposal!'
      redirect '/'
    else
      render :proposal
    end
  end
end
