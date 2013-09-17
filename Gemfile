source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~>4.0.0.rc1'
gem 'passenger'
gem 'turbolinks', '1.0.0'
gem 'gmaps4rails' # rails generate gmaps4rails:install
gem 'geocoder'
gem 'therubyracer'
gem 'nokogiri'
gem 'mysql2'

# not yet compatiable with rails4 (more specifically activerecord 4)
#gem "acts_as_paranoid", git: 'https://github.com/goncalossilva/acts_as_paranoid' #"~> 0.4.2"


# localization
gem 'rails-i18n', '~> 4.0.0.pre'
gem 'i18n-country-translations'

# currency
gem 'money-rails'
gem 'eu_central_bank'

# UI/HTML related (bootstrap/jquery etc.)
gem 'simple_form'
gem 'nested_form'
gem 'less-rails'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'
gem 'jquery-rails', '2.2.1'
gem 'bootstrap-sass'
gem 'twitter-bootstrap-rails'
gem "gritter", "1.0.3"

# for authentication and authorization
gem 'devise', '~>3.0.0'#, :git => 'https://github.com/plataformatec/devise.git'
gem 'cancan'
gem 'role_model'
gem 'rolify'
gem 'switch_user'
gem 'bcrypt-ruby', '3.0.1'
gem 'recaptcha', :require => 'recaptcha/rails'

# for file uploading and managing
gem 'paperclip', '~> 3.0'
gem 'jquery-fileupload-rails'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails', '2.13.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'selenium-webdriver', '~> 2.35.1'	
end

group :test do
  gem 'capybara', '2.1.0.beta1'
  gem 'factory_girl'
  gem 'ffaker'
end

group :assets do
  gem 'sass-rails',   '~>4.0.0.beta1'
  gem 'coffee-rails', '~>4.0.0.beta1'
  gem 'uglifier', '1.0.3'
end

group :production do
  gem 'newrelic_rpm'
end
