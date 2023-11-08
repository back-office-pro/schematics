# frozen_string_literal: true

module Schematics
  class ApplicationJob < ::ApplicationJob
    include Rollbar::ActiveJob

    retry_on ActiveRecord::Deadlocked
    discard_on ActiveJob::DeserializationError
  end
end
