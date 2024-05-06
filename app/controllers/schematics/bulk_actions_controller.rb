# frozen_string_literal: true

module Schematics
  class BulkActionsController < ApplicationController
    include Nestable

    before_action -> { authorize!(:archive, parent_model_class) }, only: :archive

    def archive
      BulkActionJob.perform_later(current_user, parent_model_class, bulk_action_params[:ids])
      head :accepted
    end

    private

    def bulk_action_params
      params.require(:bulk_action).permit(:ids)
    end
  end
end
