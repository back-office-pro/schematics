# frozen_string_literal: true

module Schematics
  class BulkActionsController < ApplicationController
    include Nestable
    include ResourcesHelper

    def create
      authorize!(:archive, parent_model_class)
      BulkActionJob.perform_later(current_user.id, parent_model_class, bulk_action_params[:ids])
      flash[:notice] = t('.success')
      respond_with nil, location: resources_path(parent_model_class)
    end

    private

    def bulk_action_params
      params.expect(bulk_action: [ids: []])
    end
  end
end
