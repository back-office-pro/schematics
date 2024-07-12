# frozen_string_literal: true

module Schematics
  class DataCleaningJob < ApplicationJob
    queue_as :cleanups

    def perform = ::DataCleaning
      .all
      .select(&:model_class)
      .each do |data_cleaning|
        data_cleaning
          .model_class
          .preload_all
          .where(data_cleaning.query_filters)
          .in_batches
          .public_send(data_cleaning.query_method)
      end
  end
end
