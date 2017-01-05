source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'puma', '~> 3.0'
gem 'pg', '~> 0.18'
gem 'sqlite3'
gem 'active_model_serializers', '~> 0.10.0'
gem 'nokogiri', '1.7.0.1', require: false
gem 'kaminari', '0.17.0'
gem 'sidekiq', '4.1.2'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails', '2.1.1'
  gem 'bullet', '5.4.0'
  gem 'rubocop', '0.42.0', require: false
  gem 'rspec-rails', '3.5.2'
  gem 'factory_girl_rails', '4.7.0', require: false
  gem 'rubycritic', '2.9.4', require: false
  gem 'brakeman', '3.4.0', require: false
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov', '0.12.0', require: false
  gem 'database_cleaner', '1.5.3'
  gem 'ffaker', '2.2.0', require: false
  gem 'shoulda-matchers', '3.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
