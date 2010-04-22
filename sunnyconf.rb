#! /usr/bin/env ruby
%w[ rubygems sinatra/base haml datamapper jadof rack/flash pony ].each {|lib| require lib }
Dir['lib/**/*.rb'].sort.each                                      {|lib| require lib }

class SunnyConf < Sinatra::Base
  use Rack::Session::Cookie
  use Rack::Flash

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
      # 'email_options = {:smtp=>{:tls => true, :host=>"smtp.gmail.com", :domain=>"sunnyconf.com", :port=>"587", :user=>"remi@sunnyconf.com", :password=>"*******", :auth=>:plain}, :via=>:smtp, :from=>"remi@sunnyconf.com"}'
      Pony.mail({ :to => email_address, :subject => subject, :body => body }.merge(email_options))
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
        email @proposal.email_with_name, 'Thank you for your SunnyConf proposal', 'Thank you for your SunnyConf proposal'
        redirect '/'
      else
        render :proposal
      end
    end
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
