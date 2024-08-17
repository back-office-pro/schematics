# frozen_string_literal: true

module Schematics
  class AutocompletionsController < ApplicationController
    include Nestable

    def create
      authorize!(:index, parent_model_class)
      respond_with parent_model_class.autocomplete(
        filter_params,
        current_ability,
        autocompletion_params
      )
    end

    private

    def autocompletion_params = params
      .require(:autocompletion)
      .permit(:field)
  end
end
