# frozen_string_literal: true

module Schematics
  class ApplicationJob < ::Tenant.application_job_class
    include Rollbar::ActiveJob

    discard_on ActiveRecord::RecordNotFound, ActiveJob::DeserializationError
    retry_on ActiveRecord::Deadlocked, wait: :polynomially_longer, attempts: 5
  end
end
