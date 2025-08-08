# encoding: UTF-8

# Copyright 2011-2013 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source 'https://rubygems.org'

ruby '3.4.4'

# Core Rails Framework
gem 'rails', '~> 6.1.7'
gem 'bootsnap', '>= 1.4.0', require: false
gem 'webpacker', '~> 5.4'
gem 'sprockets-rails', require: 'sprockets/railtie'

# Application Gems
gem 'kaminari', '~> 1.2.1'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'authlogic', '~> 6.4'                  # Updated for Ruby 3.x & Rails 6 support
gem 'cancancan', '~> 3.0'                  # Updated from 1.x for compatibility
gem 'iq_rdf', '>= 0.1.16'
gem 'iq_triplestorage'
gem 'json'
gem 'faraday', '~> 1.10'
gem 'faraday_middleware', '~> 1.2'
gem 'nokogiri', '~> 1.15'
gem 'linkeddata', '~> 3.2'
gem 'rdf-vocab'
gem 'terser'
gem 'sassc-rails', '~> 2.1'
gem 'bootstrap_form', '~> 4.0'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'apipie-rails', '~> 0.5.17'            # Compatible with Ruby 3.x
gem 'maruku', require: false
gem 'database_cleaner'
gem 'delayed_job_active_record', '~> 4.1.4'
gem 'carrierwave', '~> 2.2'
gem 'autoprefixer-rails', '~> 10.4'
gem 'daemons'
gem 'octokit', '~> 4.0'
gem 'rubyzip', '~> 2.3'
gem 'mutex_m'
gem 'csv'
gem 'benchmark'
gem 'irb'

# Database Adapters
gem 'pg', '~> 1.4'
gem 'figaro'
gem 'git'

# Development Gems
group :development do
  gem 'view_marker'
  gem 'better_errors', '~> 2.10'
  gem 'web-console', '~> 4.2'
  gem 'binding_of_caller', '~> 1.0'
end

group :development, :test do
  gem 'awesome_print'
  gem 'pry-rails', require: 'pry'
  gem 'pry-remote'
  gem 'pry-byebug', '~> 3.10'
  gem 'drb'

  platforms :ruby do
    gem 'hirb-unicode'
    gem 'cane'
  end

  platforms :jruby do
    gem 'activerecord-jdbcmysql-adapter'
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3.13'
  end
end

group :test do
  gem 'sqlite3', '~> 1.5'
  gem 'capybara', '~> 3.35'
  gem 'selenium-webdriver', '~> 4.0'
  gem 'webmock', '~> 3.14'
  gem 'simplecov', '~> 0.21'
end

group :production do
  gem 'activerecord-nulldb-adapter'
  gem 'passenger', '~> 6.0'
end
