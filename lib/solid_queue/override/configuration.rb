# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module SolidQueue
  module Override
    module Configuration
      # :reek:UtilityFunction
      def processes_config = {
        dispatchers: [
          {
            batch_size: 500,
            polling_interval: 1,
            concurrency_maintenance: true,
            concurrency_maintenance_interval: 600
          }
        ],
        workers: [
          {
            queues: %w[critical default low],
            threads: 3,
            polling_interval: 0.1,
            processes: ENV.fetch('JOB_CONCURRENCY', 1)
          }
        ]
      }

      def recurring_tasks_config = {
        clean_data: {
          class: 'Schematics::CleanDataJob',
          schedule: 'every hour'
        },
        generate_backup: {
          class: 'Schematics::GenerateBackupJob',
          schedule: 'every day at midnight'
        },
        check_license: {
          class: 'Schematics::CheckLicenseJob',
          schedule: 'every day at midnight'
        },
        migrate_core: {
          class: 'Schematics::MigrateCoreJob',
          schedule: 'every day at 1am'
        },
        migrate_schema: {
          class: 'Schematics::MigrateSchemaJob',
          schedule: 'every day at 2am'
        }
      }
    end
  end
end
