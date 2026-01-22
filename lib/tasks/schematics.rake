# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

namespace :schematics do
  desc 'Generate core application'
  task generate: :environment do
    unless Migration.table_exists?
      Schematics::Migrator
        .new
        .build_commands
        .flat_map(&:generators)
        .each(&:invoke_all)
    end
  end

  desc 'Update core application'
  task update: :environment do
    if Schematics::SchemaCache.outdated?
      PaperTrail.request(enabled: false) do
        Core::Migrations::Migrate.call(migration: Migration.core)
      end
    end
  end

  desc 'Generate application secret key base'
  task secret_key_base: :environment do
    secret = "secret_key_base: #{SecureRandom.hex(64)}"
    credentials = Rails.application.credentials
    credentials.write(credentials.read + secret) unless credentials.secret_key_base
  end
end
