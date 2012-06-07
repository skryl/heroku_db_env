# Features

* Overwrite the heroku generated database.yml config

# Installation

Add the gem to your gemfile

    gem 'heroku_db_env'

Add your database configuation to the heroku_database.yml file. For every
environment you specify, the gem will check for the existance of
ENV["#{environment}_DATABASE_URL"] and parse it into the config hash if it
exists. This way credentials and host details can be exclued from the source. 

    production:
      pool: 10

    reporting:
      host: db_reporting.hostname.com
      database: reporting_db
      username: myuser
      password: mypass
      pool: 5
      schema_search_path: reporting


Run a rake task against any configured database

    rake db:migrate RAILS_ENV=reporting
