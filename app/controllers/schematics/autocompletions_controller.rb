# frozen_string_literal: true

module Schematics
  class AutocompletionsController < ApplicationController
    include Nestable
    include Searchable

    before_action :authorize_create!, only: :create
    before_action :set_results, only: :create

    delegate :entity, to: :parent_model_class, private: true

    def create
      return unless @results.all?(String) || stale?(@results)

      render json: @results, metadata: true
    end

    private

    def autocompletion_params = params
      .require(:autocompletion)
      .permit(:query)

    def authorize_create!
      return if can?(:autocomplete, parent_model_class)

      authorize!(:index, parent_model_class)
    end

    def set_results
      @results = parent_model_class.autocomplete(
        filter_params,
        current_ability,
        autocompletion_params[:query]
      )
    end
  end
end
