# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RecurringJob < ApplicationJob # rubocop:disable Obsession/Rails/ServiceName
    queue_as :default

    def perform(job_name)
      ::ActiveJob.perform_all_later(
        Shards::List.call.shards.map(&Schematics.const_get(job_name).method(:new))
      )
    end
  end
end
