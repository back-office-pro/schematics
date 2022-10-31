# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Reindex
      include Interactor
      delegate :eager_load!, to: 'Rails.application', private: true
      delegate :models, to: '::Searchkick', private: true

      def call
        eager_load!
        models.each(&:reindex)
      end
    end
  end
end
