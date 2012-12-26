def info(text); say "\033[1m\033[36m" + 'info'.to_s.rjust(10) + "\033[0m" + "  #{text}" end

def copy_from(source, destination)
  begin
    info "fetch '#{destination}' from '#{source}'"
    remove_file destination
    get source, destination
  rescue OpenURI::HTTPError
    info "Unable to obtain #{source}"
  end
end



# RSpec for testing
gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_girl"
  gem "capybara"
end
generate "rspec:install"
run "mkdir spec/support spec/models spec/routing"
append_file '.rspec', '--format documentation'

# add database example
run "cp config/database.yml config/example_database.yml"

# application settings
application "config.generators.stylesheets = false"
application "config.generators.javascripts = false"

gsub_file "config/application.rb", "# config.i18n.default_locale = :de", "config.i18n.default_locale = :de"
gsub_file "config/application.rb", "# config.time_zone = 'Central Time (US & Canada)'", "config.time_zone = 'Berlin'"

# cleanup unnecessary files
remove_file '.gitignore'
remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

# add project.yml config
copy_from 'https://raw.github.com/endorfin/rails-templates/master/files/example_project.yml', 'config/example_project.yml'
#run "wget -O config/example_project.yml https://raw.github.com/endorfin/rails-templates/master/files/example_project.yml"
run "cp config/example_project.yml config/project.yml"
inject_into_file 'config/application.rb', after: "require 'rails/all'\n" do 
<<-RUBY

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



