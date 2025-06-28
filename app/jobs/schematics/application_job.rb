# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ApplicationJob < ::ActiveJob::Base
    include Rollbar::ActiveJob

    discard_on ActiveRecord::RecordNotFound, ActiveJob::DeserializationError, NameError
    retry_on ActiveRecord::Deadlocked, wait: :polynomially_longer, attempts: 5
  end
end
