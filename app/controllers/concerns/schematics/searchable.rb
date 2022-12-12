# frozen_string_literal: true

module Schematics
  module Searchable
    extend ActiveSupport::Concern

    def log_search!
      return unless params.key?(:filter)

      current_user
        .searches
        .create!(model: model_class, filters: filter_params_to_h)
    end
  end
end
