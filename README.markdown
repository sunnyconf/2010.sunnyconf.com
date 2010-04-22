[SunnyConf.com][sunnyconf]
==========================

Website for [http://sunnyconf.com][sunnyconf]

Downloading and running
-----------------------

    git clone git://github.com/sunnyconf/sunnyconf.com.git
    cd sunnyconf.com
    cat .gems | xargs gem install # or view .gems to see what gems you need to have
    rackup config.ru
    open http://localhost:9292/

Running the specs
-----------------

    gem install rspec capybara factory_girl factory_girl_extensions
    spec spec/

[sunnyconf]: http://sunnyconf.com
