# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RebuildSearchIndexJob < ApplicationJob
    queue_as :low

    def perform(resource)
      resource.rebuild_search_index
    end
  end
end
