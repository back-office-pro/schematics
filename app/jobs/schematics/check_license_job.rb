# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class CheckLicenseJob < ApplicationJob
    queue_as :critical

    retry_on StandardError, wait: :polynomially_longer, attempts: 5

    def perform
      Licenses::Heartbeat.call
    end
  end
end
