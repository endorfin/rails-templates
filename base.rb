# RSpec for testing
gem_group :development, :test do
  gem "rspec-rails"
end
generate :rspec

# init git repo
git :init

# add database example
run "cp config/database.yml config/example_database.yml"

# application settings
application "config.generators.stylesheets = false"
application "config.generators.javascripts = false"

gsub_file "config/application.rb", "# config.i18n.default_locale = :de", "config.i18n.default_locale = :de"
gsub_file "config/application.rb", "# config.time_zone = 'Central Time (US & Canada)'", "config.time_zone = 'Berlin'"

# cleanup unnecessary files
run "rm .gitignore public/index.html app/assets/images/rails.png"

# gitignore
file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

# initial commit
git :add => ".", :commit => "-m 'initial commit'"