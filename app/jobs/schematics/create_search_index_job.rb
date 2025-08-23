# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class CreateSearchIndexJob < ApplicationJob
    queue_as :low

    def perform(resource)
      resource.create_search_index
    end
  end
end
