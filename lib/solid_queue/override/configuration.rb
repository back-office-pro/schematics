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
      def processes_config
        super.tap { _1[:workers][0][:queues] = %w[critical default low] }
      end

      def recurring_tasks_config
        @recurring_tasks_config ||= {
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
end
