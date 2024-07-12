# frozen_string_literal: true

module Schematics
  class DataCleaningJob < ApplicationJob
    include Quietable
    queue_as :cleanups

    def perform = ::DataCleaning
      .all
      .select(&:model_class)
      .each(&:run_query!)
  end
end
