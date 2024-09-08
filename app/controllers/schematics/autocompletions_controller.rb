# frozen_string_literal: true

module Schematics
  class AutocompletionsController < ApplicationController
    include Nestable
    include Searchable

    delegate :entity, to: :parent_model_class, private: true

    def create
      authorize!(:index, parent_model_class)
      render json: parent_model_class.autocomplete(
        filter_params,
        current_ability,
        autocompletion_params[:field]
      )
    end

    private

    def autocompletion_params = params
      .require(:autocompletion)
      .permit(:field)
  end
end
