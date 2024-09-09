# frozen_string_literal: true

module Schematics
  class AutocompletionsController < ApplicationController
    include Nestable
    include Searchable

    before_action :authorize_create!
    delegate :entity, to: :parent_model_class, private: true

    def create
      render json: parent_model_class.autocomplete(
        filter_params,
        current_ability,
        autocompletion_params[:field]
      ), metadata: true
    end

    private

    def autocompletion_params = params
      .require(:autocompletion)
      .permit(:field)

    def authorize_create!
      return if can?(:autocomplete, parent_model_class)

      authorize!(:index, parent_model_class)
    end
  end
end
