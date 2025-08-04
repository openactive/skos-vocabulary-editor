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

# TODO: The following dependencies could be included by the "gemspec" command.
# There is only one problem: gemspec puts the dependencies automatically to a
# group (:development by default). This is not what we need.
gem 'rails'#, '~> 4.2.11'
gem 'kaminari', '~> 1.2.1'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'authlogic', '~> 3.8.0'
gem 'cancancan', '~> 1.10.0'
gem 'iq_rdf', '>= 0.1.16'
gem 'iq_triplestorage'
gem 'json'
gem 'rails_autolink'
gem 'faraday', '0.9.0'
gem 'faraday_middleware'
gem 'nokogiri'
gem 'linkeddata', '~> 3.1.0' # With no specified version this resolves to 3.0.3, which requires nokogumbo-2.0.5, which Ruby-3 has an issue with installing. linkeddata-3.1 is the next highest version and works fine with Ruby-3 (Ruby-3.2.8, Ruby-3.3.8, Ruby-3.4.4 tested), so does linkeddata-3.2, but linkeddata-3.3 causes a lot of dependency clashes (linkeddata-3.3.3 is the very latest version as of 2025-08-01). Sticking with the lowest version which works, while restricting minor version, hence linkeddata ~> 3.1.0.
gem "rdf-vocab"
gem 'uglifier'
gem 'sass-rails', '~> 5.0.0'
gem 'bootstrap_form', '~> 2.2.0'
gem 'font-awesome-rails', '~> 4.3.0'
gem 'apipie-rails', '~> 0.3.5'
gem 'maruku', require: false
gem 'database_cleaner'
gem 'delayed_job_active_record', '~> 4.1.1'
gem 'carrierwave'
gem 'autoprefixer-rails', '~> 6.5.1.1'
gem 'daemons'
gem "octokit", "~> 4.0"
gem 'rubyzip', '~> 2.0'
gem 'activerecord', '>= 3.2.15' # If activerecord is not specified at all then activerecord-3.2.14 is pulled in by linkeddata, but this has issues with unspecified dependencies which is not so with activerecord-3.2.13 and activerecord-3.2.15 (see rubygems.org for all these versions), so looks like maybe an oversight with activerecord-3.2.14. Explicitly specifying activerecord-3.2.15 as a minimum avoids this. Note that '~> 3.2.15' limits us to '>= 3.2.15' and '< 3.3', but the latter constraint leads to other dependency issues, hence we use '>= 3.2.15' here.

# database adapters
# comment out those you do don't need or use a different Gemfile
# gem  'mysql2', '~> 0.4.0'
gem 'pg'#, '~> 0.15' # Ruby-3 has an issue with this version
gem 'figaro'
gem 'git'

group :development do
  gem 'view_marker'
  gem 'better_errors'
  gem 'web-console'
  gem 'binding_of_caller', '0.7.3.pre1'
end

group :development, :test do
  gem 'awesome_print'
  gem 'pry-rails', require: 'pry'
  gem 'pry-remote'
  gem 'pry-byebug', '~> 1.1.2', platforms: :ruby_20
  gem 'quiet_assets'

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
  gem 'sqlite3'#, '~> 1.3.0' # Ruby-3 has an issue with this version
  gem 'capybara', '~> 2.14.2'
  gem 'poltergeist', '~> 1.6.0'
  gem 'webmock', '~> 3.0.1'
  gem 'simplecov'
end

group :production do
  gem 'activerecord-nulldb-adapter'
  #version updates must be done in the Dockerfile as well
  gem 'passenger', '= 5.3.7'
  gem 'rails_12factor'
end

platforms :ruby do
  # gem 'therubyracer' # Not needed for deployment to heroku, not is the newer mini_racer
end

group :heroku do
  gem 'rails_12factor'
end
