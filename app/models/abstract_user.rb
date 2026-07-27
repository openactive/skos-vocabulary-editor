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

class AbstractUser < ActiveRecord::Base
  self.table_name = 'users'

  delegate :can?, :cannot?, :to => :ability

  validates_presence_of :email
  validates_uniqueness_of :email
  # validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  acts_as_authentic do |config|
    # Authlogic 4+ removed its built-in field validations, so `validate_email_field`
    # no longer exists. Email is validated explicitly above (presence/uniqueness).
    #
    # Name the credential columns explicitly. Authlogic otherwise infers them by
    # inspecting the table (`first_column_to_exist`), which silently returns nil
    # when no database connection is available - and the result is memoised for
    # the life of the process. Under Passenger the app is preloaded before a
    # connection exists ("Failed to define attribute methods because of
    # ActiveRecord::ConnectionNotEstablished"), so login_field/email_field became
    # nil, which made the session's password_field nil and raised
    # `'@' is not allowed as an instance variable name` on every request that
    # touched current_user. These values match what Authlogic detects anyway.
    config.login_field           = :email
    config.crypted_password_field = :crypted_password
    config.password_salt_field   = :password_salt

    config.crypto_provider = Authlogic::CryptoProviders::Sha512 # keep legacy Sha512 hashes valid
    # Authlogic 6 replaced `maintain_sessions = false` with these flags: do not
    # automatically create/maintain a session when a user record is saved.
    config.log_in_after_create = false
    config.log_in_after_password_change = false
  end

  def self.default_role
    'reader'
  end

  def name
    "#{forename} #{surname}"
  end

  def to_s
    self.name.to_s
  end

  def owns_role?(name)
    self.role == name.to_s
  end

  def ability
    @ability ||= Ability.new(self)
  end
end
