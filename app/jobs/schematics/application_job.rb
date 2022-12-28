# frozen_string_literal: true

module Schematics
  class ApplicationJob < ::ApplicationJob
    discard_on ActiveJob::DeserializationError
  end
end
