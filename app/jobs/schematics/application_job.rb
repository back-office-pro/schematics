# frozen_string_literal: true

module Schematics
  class ApplicationJob < ::ApplicationJob
    include Rollbar::ActiveJob
    discard_on ActiveJob::DeserializationError
  end
end
