# RSpec for testing
gem_group :development, :test do
  gem "rspec-rails"
end
generate :rspec

# add database example
run "cp config/database.yml config/example_database.yml"

# application settings
application "config.generators.stylesheets = false"
application "config.generators.javascripts = false"

gsub_file "config/application.rb", "# config.i18n.default_locale = :de", "config.i18n.default_locale = :de"
gsub_file "config/application.rb", "# config.time_zone = 'Central Time (US & Canada)'", "config.time_zone = 'Berlin'"

# cleanup unnecessary files
run "rm .gitignore public/index.html app/assets/images/rails.png"

# add project.yml config
run "wget -O config/example_project.yml https://raw.github.com/endorfin/rails-templates/master/files/example_project.yml"
run "cp config/example_project.yml config/project.yml"
inject_into_file 'config/application.rb', after: "require 'rails/all'\n" do <<-'RUBY'

CONFIG = YAML.load(File.read(File.expand_path('../project.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!
RUBY
end

# init git repo
git :init

# gitignore
file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
config/project.yml
db/*.sqlite3
END

# initial commit
git :add => ".", :commit => "-m 'initial commit'"



