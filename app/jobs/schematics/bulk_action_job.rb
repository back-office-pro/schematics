# frozen_string_literal: true

module Schematics
  class BulkActionJob < ApplicationJob
    limits_concurrency key: ->(*args) { args }, on_conflict: :discard
    queue_as :default

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
