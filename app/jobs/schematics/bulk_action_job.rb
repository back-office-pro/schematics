# frozen_string_literal: true

module Schematics
  class BulkActionJob < ApplicationJob
    queue_as :cleanups

    def perform(user, model_class, ids)
      PaperTrail.request(whodunnit: user) do
        model_class
          .preload_all
          .where(id: ids)
          .find_each { |resource| Resources::Archive.call(resource:) }
      end
    end
  end
end
