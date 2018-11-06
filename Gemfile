source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use Haml as as markup language
gem 'haml-rails', '~> 1.0.0'
# Use bootstrap library
gem 'bootstrap', '~> 4.1.3'
# Use chosen library for select boxes
gem 'chosen-rails'
# Use font awesome
gem 'font-awesome-rails'
# Use devise for user authentication
gem 'devise', '~> 4.5.0'
# Use devise invitable for user invitations
gem 'devise_invitable', '~> 1.7.5'
# Use pundit for authorization
gem 'pundit', '~> 2.0.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use friendly_id for pretty URLs
gem 'friendly_id', '~> 5.2.4'
# Use public activity for model tracking
gem 'public_activity', '~> 1.6.2'
# Use kaminari for pagination
gem 'kaminari', '~> 1.1.1'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Use dotenv-rails to load env variables in development
  gem 'dotenv-rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'thin', '~> 1.7.2'
  gem 'letter_opener', '~> 1.6.0'
  gem 'rack-mini-profiler'
  gem 'bullet', '~> 5.8.1'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]