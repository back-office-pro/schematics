# frozen_string_literal: true

module Schematics
  class BulkActionsController < ApplicationController
    include Nestable

    def create
      authorize!(:archive, parent_model_class)
      BulkActionJob.perform_later(current_user.id, parent_model_class, bulk_action_params[:ids])
      flash[:notice] = t('.success')
      respond_with nil, location: main_app.polymorphic_path(parent_model_class)
    end

    private

    def bulk_action_params = params
      .require(:bulk_action)
      .permit(ids: [])
  end
end
