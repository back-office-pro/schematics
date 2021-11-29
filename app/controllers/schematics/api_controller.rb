# frozen_string_literal: true

module Schematics
  class ApiController < ApplicationController
    before_action :set_paper_trail_whodunnit
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # TODO: rescue RecordInvalid
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from CanCan::AccessDenied, with: :forbidden

    def parameter_missing(exception)
      respond_to do |format|
        format.html do
          redirect_back fallback_location: schematics.root_path,
                        alert: t('schematics.api.parameter_missing.alert')
        end
        format.json do
          render json: { errors: [{ exception.param => ['parameter is required'] }] },
                 status: :bad_request
        end
      end
    end

    def forbidden
      respond_to do |format|
        format.html do
          redirect_to schematics.root_path, alert: t('schematics.api.forbidden.alert')
        end
        format.json { head :forbidden }
      end
    end

    def not_found
      respond_to do |format|
        format.html do
          redirect_to not_found_path,
                      alert: t('schematics.api.not_found.alert', model_name: model_name.human)
        end
        format.json { head :not_found }
      end
    end

    private

    def not_found_path
      polymorphic_path(model_class)
    end
  end
end
