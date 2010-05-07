#! /usr/bin/env ruby
require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'datamapper'
require 'jadof'
require 'rack/flash'
require 'pony'

Dir['lib/**/*.rb'].sort.each                                           {|lib| require lib }

class SunnyConf < Sinatra::Base
  use Rack::Session::Cookie
  use Rack::Flash

  set :root, Dir.pwd

  helpers do

    def cache!
      headers['Cache-Control'] = 'public, max-age=300' if ENV['RACK_ENV'] == 'production'
    end

    def page name
      JADOF::Page[name].to_html
    end

    def email email_address, subject, body
      raise "You must specify an environment variable named EMAIL_OPTIONS" unless ENV['EMAIL_OPTIONS']
      email_options = eval(ENV['EMAIL_OPTIONS'])
      # Example options:
      # '{:smtp=>{:tls => true, :host=>"smtp.gmail.com", :domain=>"sunnyconf.com", :port=>"587", :user=>"noreply@sunnyconf.com", :password=>"******", :auth=>:plain}, :via=>:smtp, :from=>"noreply@sunnyconf.com"}'
      Pony.mail({ :to => email_address, :subject => subject, :body => body }.merge(email_options))
    end

    def partial(page, options={})
      haml page, options.merge!(:layout => false)
    end

  end

  get '/' do
    @proposal = Proposal.new
    haml :index
  end

  post '/proposals' do
    @proposal = Proposal.new params[:proposal]

    case params[:commit]
    when 'Preview Your Proposal'
      haml @proposal.valid? ? :proposal_preview : :proposal

    when 'Edit Proposal'
      haml :proposal

    when 'Submit Proposal'
      if @proposal.save
        flash[:notice] = 'Thank you for your proposal!'
        
        # Send thank you to submitter
        to      = @proposal.email_with_name
        subject = 'Thank you for your SunnyConf proposal'
        body    = 'Thank you for your SunnyConf proposal'
        email to, subject, body
        
        # Notification to SunnyConf Team
        to      = ENV['INCOMING_EMAIL'] || 'info@sunnyconf.com'
        subject = "#{@proposal.name} submitted a proposal for SunnyConf"
        body    = "From: #{@proposal.name} <#{@proposal.email}>\n\n#{@proposal.text}"
        email to, subject, body

        redirect '/'
      else
        render :proposal
      end
    end
  end

  get '/stylesheets/application.css' do
    cache!
    content_type 'text/css'
    sass :stylesheet
  end

  # Catch-All (renders pages in ./pages/)

  get '/*' do
    cache!
    @page = JADOF::Page.get params[:splat]
    if @page
      haml @page.to_html
    else
      status 404
    end
  end
end
