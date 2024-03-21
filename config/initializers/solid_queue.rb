# frozen_string_literal: true

Rails.application.configure do
  opts = Schematics::Engine.config_for(:backend)
  SolidQueue::Configuration::WORKER_DEFAULTS[:queues] = opts[:queues]
  SolidQueue::Configuration::DISPATCHER_DEFAULTS[:recurring_tasks] = opts
    .dig(:scheduler, :schedule)
    .transform_values { _1.transform_keys(cron: :schedule) }
end
