# frozen_string_literal: true

module Schematics
  module Rescuable
    extend ActiveSupport::Concern

    included do
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from CanCan::AccessDenied, with: :forbidden
    end

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

    def not_found
      respond_to do |format|
        format.json { head :not_found }
        format.any do
          redirect_to not_found_path,
                      alert: t('schematics.api.not_found.alert', human_name:, gender:)
        end
      end
    end

    def forbidden
      respond_to do |format|
        format.json { head :forbidden }
        format.any do
          redirect_to schematics.root_path, alert: t('schematics.api.forbidden.alert')
        end
      end
    end

    protected

    def not_found_path
      polymorphic_path(model_class)
    end
  end
end
