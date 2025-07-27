# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class CleanDataJob < ApplicationJob
    include Shardable
    include Quietable

    queue_as :low

    def perform(_shard)
      ::DataCleaning
        .all
        .select(&:model_class)
        .each { |data_cleaning| Core::DataCleanings::Run.call(data_cleaning:) }
    end
  end
end
