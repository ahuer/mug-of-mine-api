# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'jbuilder', '~> 2.5'
gem 'rack-cors'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.3'
gem 'sqlite3', group: :development
gem 'pg', group: :production
gem 'rails_12factor'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'nokogiri', '1.8.1'
gem 'cloudinary'

group :development, :test do
  gem 'pry-nav'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rubocop', '~> 0.49', require: false
end

group :test do
  gem 'vcr', '~> 3.0'
  gem 'webmock'
  gem 'mocha'
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mini_racer', platforms: :ruby
