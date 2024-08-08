# frozen_string_literal: true

module Schematics
  class ApplicationJob < ::Tenant.application_job_class
    include Rollbar::ActiveJob

    retry_on ActiveRecord::Deadlocked
    discard_on ActiveRecord::RecordNotFound,
               ActiveJob::DeserializationError
  end
end
