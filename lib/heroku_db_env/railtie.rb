module HerokuDbEnv
  class HerokuDbEnvRailtie < Rails::Railtie

    initializer "heroku_db_env_railtie.initialize_database" do |app|
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.configurations = \
          HerokuDbEnv.generate_heroku_db_config(app.config.database_configuration)
        ActiveRecord::Base.establish_connection
      end
    end

  end

class << self

  def generate_heroku_db_config(default_config = {})
    heroku_config = load_heroku_db_config(Rails.root.join('config/heroku_database.yml'))
    merge_db_env( default_config.with_indifferent_access.deep_merge(heroku_config) )
  end

private

  def load_heroku_db_config(db_yml)
    return {} unless File.exists?(db_yml)
    require 'erb'
    YAML::load(ERB.new(IO.read(db_yml)).result)
  end

  def merge_db_env(db_config)
    return {} unless db_config.is_a? Hash
    db_config.each do |env, config| 
      db_config[env] = \
        if env_db_url(env)
          resolver = ActiveRecord::Base::ConnectionSpecification::Resolver.new(env_db_url(env), {})
          config.merge(resolver.spec.config)
        else config
        end
    end
  end

  def env_db_url(env)
    ENV["#{env.upcase}_DATABASE_URL"]
  end

end

end
