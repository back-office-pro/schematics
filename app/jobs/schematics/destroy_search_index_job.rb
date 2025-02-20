# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class DestroySearchIndexJob < ApplicationJob
    queue_as :low

    def perform(**)
      SearchIndex.delete_by(**)
    end
  end
end
