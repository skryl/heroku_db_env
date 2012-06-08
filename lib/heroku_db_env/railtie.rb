module HerokuDbEnv
  DB_URL_MATCHER = /(.*)_DATABASE_URL/

  class HerokuDbEnvRailtie < Rails::Railtie
    config.before_initialize do |app| 
      db_config = HerokuDbEnv.build_db_config(app.config.database_configuration)
      app.config.class_eval do
        define_method(:database_configuration) { db_config }
      end
    end
  end


class << self

  def build_db_config(default_config = {})
    heroku_config = load_heroku_db_config(Rails.root.join('config/heroku_database.yml'))
    overlay_configs(default_config, heroku_config, env_config)
  end

private

  def load_heroku_db_config(db_yml)
    return {} unless File.exists?(db_yml)
    require 'erb'
    YAML::load(ERB.new(IO.read(db_yml)).result)
  end

  def env_config
    db_env.inject({}) do |a, (env, config)| 
      resolver = ActiveRecord::Base::ConnectionSpecification::Resolver.new(config, {})
      a[env.match(DB_URL_MATCHER)[1].downcase] = resolver.spec.config; a
    end
  end

  def db_env
    ENV.select { |k,v| DB_URL_MATCHER === k }
  end

  def overlay_configs(*configs)
    configs.inject({}) do |a, c|
      a.deep_merge(c.with_indifferent_access)
    end
  end

end
end
