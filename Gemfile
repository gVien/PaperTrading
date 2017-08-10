source 'https://rubygems.org'

ruby "2.3.4"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Sass Bootstrap for Rails
gem 'bootstrap-sass', '~> 3.3.5'  #converts Less to Sass, since Rails asset pipeline supports the Sass language by default
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# using oauth to make call to APIs
gem "oauth"

# # needed for em-http-request
gem "simple_oauth"

# even machine for streaming
gem "em-http-request"

# let's party it up and consume APIs!!
gem "httparty"

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# gem to populate fake data
gem "faker", "1.4.3"

# pagination and bootstrap
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'

# carrierwave is image uploader for Ruby apps
gem 'carrierwave'
# mini-magick is image resizing (it's a wrapper for imagemagick gem)
gem 'mini_magick',             '3.8.0'
# fog is image uploader for the cloud (e.g. AWS)
gem 'fog',                     '1.26.0'

# other gem options include: `gem install rails_autolink` (used to be part of Rails) or
# `gem rinku` (faster since it's written in C)
# autodetect url and turns into other resources (image, link, YouTube, Vimeo video,...)
gem "auto_html"

# friendly_id to convert id to stock symbol (or username)
# e.g. /stocks/1 => stocks/ABC
gem 'friendly_id', '~> 5.1.0'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # dot env for storing ENV variables (e.g. consumer key, access token, etc)
  gem 'dotenv-rails'

  # better errors in front end to help with debugging
  gem "better_errors"
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'puma',           '2.15.3'
end

