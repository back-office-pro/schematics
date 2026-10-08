# frozen_string_literal: true

module SolidQueue
  module Override
    module Configuration
      # :reek:UtilityFunction
      def processes_config = {
        dispatchers: [
          batch_size: 500,
          polling_interval: 1,
          concurrency_maintenance: true,
          concurrency_maintenance_interval: 600
        ],
        workers: [
          queues: %w[critical default low],
          threads: 3,
          polling_interval: 0.1,
          processes: ENV.fetch('JOB_CONCURRENCY', 1)
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
          schedule: 'every hour'
        },
        migrate_schema: {
          class: 'Schematics::MigrateSchemaJob',
          schedule: 'every day at 2am'
        }
      }
    end
  end
end
