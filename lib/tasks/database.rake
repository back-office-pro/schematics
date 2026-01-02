# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_record_doctor'
require 'active_record_doctor/rake/task'

namespace :schematics do
  namespace :db do
    desc 'Perform database backup'
    task backup: :environment do
      Schematics::GenerateBackupJob.perform_now
    end

    ActiveRecordDoctor::Rake::Task.new do |task|
      task.deps = [:environment]
      task.config_path = Rails.root.join('config/active_record_doctor.rb')
      task.setup = -> { Rails.application.eager_load! }
    end

    namespace :migrate do
      desc 'Migrate database from sqlite3 to postgres'
      task postgres: :environment do
        db_path = Rails.root.join('db', "#{Rails.env}.sqlite3")
        db_name = Rais.env
        `createdb #{db_name}`
        `pgloader --with "preserve index names" sqlite://#{db_path} postgres://localhost/#{db_name}`
      end
    end

    namespace :encryption do
      desc 'Generate database encryption credentials'
      task init: :environment do
        config = `rails db:encryption:init | tail -n +3`
        credentials = Rails.application.credentials
        credentials.write(credentials.read + config) unless credentials.active_record_encryption
      end
    end
  end
end
