[SunnyConf.com][sunnyconf]
==========================

Website for [http://sunnyconf.com][sunnyconf]

Downloading and running
-----------------------

    git clone git://github.com/sunnyconf/sunnyconf.com.git
    cd sunnyconf.com
    bundle install
    ./script/server
    open http://localhost:3000/
    
Pushing to staging, production, and GitHub
------------------------------------------

    You'll need be added to the repos in all three cases

    staging: 
      sunnyconf-staging.heroku.com
      git remote add staging git@heroku.com:sunnyconf-staging.git
      git push staging master
      
    production:
      sunnyconf.heroku.com
      git remote add heroku git@heroku.com:sunnyconf.git
      git push heroku master
    
    github.com/sunnyconf/sunnyconf.com
      git remote add origin git@github.com:sunnyconf/sunnyconf.com.git
      git push origin master

[sunnyconf]: http://sunnyconf.com
