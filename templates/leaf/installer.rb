require 'rbconfig'

file 'Gemfile', <<-GEMFILE

source "https://rubygems.org"

gem "rails", "3.2.11"

# gems used by leaf

gem "jquery-rails"
gem "rack-cache", :require => "rack/cache"
gem 'acts_as_list'
gem 'awesome_nested_set'
gem 'cancan', '~> 1.6.8'
gem 'devise', '~> 2.1.2'
gem 'dragonfly', '~>0.9.12'
gem 'globalize3'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'leaf', :git => 'git@github.com:cubesystems/leaf.git'
gem 'mysql2'
gem 'rack-cache', :require => 'rack/cache'
gem 'rails-settings-cached', :git => 'https://github.com/graudeejs/rails-settings-cached'
gem 'stringex'
gem 'strong_parameters'
gem 'tinymce-rails', '~> 3.5.8'
gem 'tinymce-rails-imageupload'
gem 'will_paginate', '~> 3.0.4'
gem 'yui-rails', :git => 'https://github.com/ConnectCubed-Open/yui-rails'

gem "unicorn"

group :assets do
 gem "sass-rails", "~> 3.2.5"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem "uglifier", ">= 1.0.3"
end

group :development do
  gem "capistrano"
  gem "capistrano-ext"
  gem "rvm-capistrano"
  gem "guard-spin"
  gem "brakeman", "~>1.8.3"

  # gem 'debugger'
  # gem 'ruby-debug19', :require => 'ruby-debug'
  # gem 'better_errors'
  ## https://github.com/banister/binding_of_caller/issues/8
  # gem 'binding_of_caller'
end

group :development, :test, :demo do
  gem "rspec-rails"
  gem "capybara"
  gem "factory_girl_rails"
  gem "simplecov", :require => false, :platforms => :mri_19
  gem "database_cleaner"
end

GEMFILE

run 'cp config/database.yml config/database.yml.example'
run 'rm -f "db/seeds.rb" "public/index.html" "public/images/rails.png" "app/views/layouts/application.html.erb" "config/routes.rb"'


# load in RVM environment
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    rvm_path     = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
    rvm_lib_path = File.join(rvm_path, 'lib')
    $LOAD_PATH.unshift rvm_lib_path

    require 'rvm'
  rescue LoadError
    # RVM is unavailable at this point.
    raise "RVM ruby lib is currently unavailable."
  end
else
  raise "RVM ruby lib is currently unavailable."
end

rvm_env = "1.9.3@#{app_name}"

# create rvmrc file
file ".rvmrc", <<-END
rvm #{rvm_env}
END

say "Creating RVM gemset #{app_name}"
RVM.gemset_create app_name

say "Trusting project's .rvmrc"
run "rvm rvmrc trust"

say "Switching to use RVM gemset #{app_name}"
RVM.gemset_use! app_name


if run("gem list --installed bundler", :capture => true) =~ /false/
  run "gem install bundler --no-rdoc --no-ri"
end

run 'bundle install'
rake 'db:create'

generate "settings settings"
generate "devise:install"
generate "leaf:install #{ARGV.join(' ')}"
rake 'db:migrate'

file 'config/initializers/dragonfly.rb', "require 'dragonfly/rails/images'"
gsub_file 'config/application.rb', 'config.active_record.whitelist_attributes = true', 'config.active_record.whitelist_attributes = false'

file 'config/routes.rb', <<-ROUTES
#{app_name.capitalize}::Application.routes.draw do
  mount_leaf_at '/admin'

  namespace :admin do
    resources :admins, :roles do
      get   :confirm_destroy, :on => :member
      match :urls, :on => :collection
    end
  end

end
ROUTES

rake 'db:seed'
run 'git init .'
run 'git add .'
run 'git commit -a -m "initialize project"'

say <<-SAY
  ===================================================================================
    Your new Leaf application is now installed and admin interface mounts at '/admin'
  ===================================================================================
SAY
