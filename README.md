## Features

* Overwrite Heroku's auto generated database configuration

## Installation

Add the gem to your gemfile

    gem 'heroku_db_env'

Add your custom database configuation or overrides to the heroku_database.yml
file. The format is identical to database.yml. The gem will also look for any 
environment variables in the format [env]_DATABASE_URL and merge the resulting
connection hash into the database configuation.

## Example

Lets assume that you are running in your production environment and your
DATABASE_URL is set to 

    postgres://user:pass@hostname/db_prod

Heroku's auto-generated database.yml is actually an ERB script which will
transform the DATABASE_URL environment variable to the following connection
config when the file is read

  production:
    adapter: postgres
    database: db_prod
    username: user
    password: pass
    host: hostname

Now lets say, for whatever reason, you are unhappy with the auto generated
database configuration. You can overwrite it by providing a heroku_database.yml
file in your config directory and/or by specifying environment specific
DATABASE_URL env vars.

In your heroku_database.yml

    production:
      pool: 10

    reporting:
      pool: 5
      schema_search_path: reporting_schema

And your REPORTING_DATABASE_URL is set to

    postgres://user:pass@reporting.hostname/db_reporting

The final database configuration should look like

  production:
    adapter: postgres
    database: db_prod
    username: user
    password: pass
    host: hostname
    pool: 10
  reporting:
    adapter: postgres
    database: db_reporting
    username: user
    password: pass
    host: reporting.hostname
    pool: 5
    schema_search_path: reporting_schema

Run a db rake task against any configured database to test the setup

    rake db:migrate RAILS_ENV=reporting
