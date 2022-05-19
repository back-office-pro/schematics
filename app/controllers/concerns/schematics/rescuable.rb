# frozen_string_literal: true

module Schematics
  module Rescuable
    extend ActiveSupport::Concern

    included do
      rescue_from CanCan::AccessDenied, with: :access_denied
      rescue_from AASM::InvalidTransition, with: :invalid_transition
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::StaleObjectError, with: :stale_object_error
      rescue_from ActionController::UnknownFormat, with: :unknown_format
    end

    def access_denied
      respond_to do |format|
        format.json { head :forbidden }
        format.any do
          redirect_to schematics.root_path, alert: t('schematics.application.access_denied.alert')
        end
      end
    end

    def invalid_transition(exception)
      respond_to do |format|
        format.html do
          redirect_back_or_to @resource,
                              alert: t('schematics.application.invalid_transition.alert')
        end
        format.json do
          render json: { errors: [{ exception.state_machine_name => [exception.message] }] },
                 status: :method_not_allowed
        end
      end
    end

    def parameter_missing(exception)
      respond_to do |format|
        format.html do
          redirect_back_or_to schematics.root_path,
                              alert: t('schematics.application.parameter_missing.alert')
        end
        format.json do
          render json: { errors: [{ exception.param => ['parameter is required'] }] },
                 status: :bad_request
        end
      end
    end

    def record_not_found
      respond_to do |format|
        format.json { head :not_found }
        format.any do
          alert = t('schematics.application.record_not_found.alert', human_name:, gender:)
          redirect_to index_path, alert:
        end
      end
    end

    def stale_object_error
      respond_to do |format|
        format.json { head :precondition_failed }
        format.html do
          @resource.errors.add(:base, :stale)
          flash.now[:alert] = t('schematics.application.stale_object_error.alert')
          render :edit, status: :precondition_failed
        end
      end
    end

    def unknown_format
      respond_to do |format|
        format.json { head :not_acceptable }
        format.any do
          redirect_to schematics.root_path, alert: t('schematics.application.unknown_format.alert')
        end
      end
    end

    protected

    def index_path
      return polymorphic_path(model_class) if can?(:index, model_class)

      schematics.root_path
    end
  end
end
