# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class BulkActionsController < ApplicationController
    include Nestable
    include ResourcesHelper

    def create
      authorize!(:archive, parent_model_class)
      BulkActionJob.perform_later(
        current_tenant.subdomain,
        current_user.id,
        parent_model_name,
        bulk_action_params[:ids]
      )
      flash[:notice] = t('.success')
      head :created, location: resources_path(parent_model_class)
    end

    private

    def bulk_action_params
      params.expect(bulk_action: [ids: []])
    end
  end
end
