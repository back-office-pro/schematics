# frozen_string_literal: true

module Schematics
  class BulkActionJob < ApplicationJob
    queue_as :cleanups

    def perform(whodunnit, model_class, ids)
      PaperTrail.request(whodunnit:) do
        model_class
          .preload_all
          .where(id: ids)
          .find_each { |resource| Resources::Archive.call(resource:) }
      end
    end
  end
end
