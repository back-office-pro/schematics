# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class CheckLicenseJob < ApplicationJob
    queue_as :critical

    def perform
      Licenses::Heartbeat.call
    end
  end
end
