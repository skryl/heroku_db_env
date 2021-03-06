# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "heroku_db_env/version"

Gem::Specification.new do |s|
  s.name        = "heroku_db_env"
  s.version     = HerokuDbEnv::VERSION
  s.authors     = ["Alex Skryl"]
  s.email       = ["rut216@gmail.com"]
  s.homepage    = "http://github.com/skryl/heroku_db_env"
  s.summary     = %q{Overwrite Heroku's auto generated database configuration}
  s.description = %q{Use a custom database configuration in a Heroku application}

  s.rubyforge_project = "heroku_db_env"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"

end
