# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class NotifyJob < ApplicationJob
    queue_as :low

    def perform(item, event, user)
      Version.find_or_create_by!(item:, event:, user:)
    end
  end
end
