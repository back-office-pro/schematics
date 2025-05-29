# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RecurringJob < ApplicationJob # rubocop:disable Obsession/Rails/ServiceName
    queue_as :default

    def perform(job_name)
      ::ActiveJob.perform_all_later(shards.map { Schematics.const_get(job_name).new(_1) })
    end

    private

    def shards
      return %i[default] if Rails.env.test?

      Rails
        .root
        .glob('storage/*')
        .map(&:basename)
        .map(&:to_s)
        .map(&:to_sym)
    end
  end
end
