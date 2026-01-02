# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Rescuable # rubocop:disable Metrics/ModuleLength
    extend ActiveSupport::Concern

    included do
      rescue_from CanCan::AccessDenied, with: :access_denied
      rescue_from AASM::InvalidTransition, with: :invalid_transition
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::StaleObjectError, with: :stale_object_error
      rescue_from ActionController::UnknownFormat, with: :unknown_format
      rescue_from ActionController::TooManyRequests, with: :too_many_requests
      rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :invalid_token
      rescue_from Triggers::Errors::StandardError, with: :trigger_error
      rescue_from Aws::S3::Errors::ServiceError, with: :storage_error
      rescue_from Google::Cloud::Error, with: :storage_error
      rescue_from AzureBlob::Error, with: :storage_error
    end

    def access_denied
      switch_localization do
        respond_to do |format|
          format.json { head :forbidden }
          format.any do
            redirect_to root_path, alert: t('schematics.application.access_denied.alert')
          end
        end
      end
    end

    def invalid_transition(exception)
      switch_localization do
        respond_to do |format|
          format.html do
            redirect_back_or_to show_path,
                                alert: t('schematics.application.invalid_transition.alert')
          end
          format.json do
            render json: { errors: [{ exception.state_machine_name => [exception.message] }] },
                   status: :method_not_allowed
          end
        end
      end
    end

    def parameter_missing(exception)
      switch_localization do
        respond_to do |format|
          format.html do
            redirect_back_or_to root_path,
                                alert: t('schematics.application.parameter_missing.alert')
          end
          format.json do
            render json: { errors: [{ exception.param => ['parameter is required'] }] },
                   status: :bad_request
          end
        end
      end
    end

    def record_not_found
      switch_localization do
        respond_to do |format|
          format.json { head :not_found }
          format.any do
            redirect_to index_path,
                        alert: t('schematics.application.record_not_found.alert', human_name:, gender:) # rubocop:disable Layout/LineLength
          end
        end
      end
    end

    def stale_object_error(exception)
      return unless action_name == 'update'

      switch_localization do
        respond_to do |format|
          format.json { head :precondition_failed }
          format.html do
            exception.record.errors.add(:base, :stale)
            flash.now[:alert] = t('schematics.application.stale_object_error.alert')
            render :edit, status: :precondition_failed
          end
        end
      end
    end

    def unknown_format
      switch_localization do
        respond_to do |format|
          format.json { head :not_acceptable }
          format.any do
            redirect_to root_path, alert: t('schematics.application.unknown_format.alert')
          end
        end
      end
    end

    def invalid_token
      switch_localization do
        respond_to do |format|
          format.json { head :bad_request }
          format.any do
            redirect_to index_path, alert: t('schematics.application.invalid_token.alert')
          end
        end
      end
    end

    def trigger_error(exception)
      switch_localization do
        respond_to do |format|
          format.any { redirect_to index_path, alert: exception.to_s }
          format.json do
            render json: { errors: [trigger: [exception.to_s]] }, status: :bad_request
          end
        end
      end
    end

    def storage_error(exception)
      switch_localization do
        respond_to do |format|
          format.any { redirect_back_or_to root_path, alert: exception.to_s }
          format.json do
            render json: { errors: [storage: [exception.to_s]] }, status: :bad_request
          end
        end
      end
    end

    def too_many_requests
      switch_localization do
        respond_to do |format|
          format.json { head :too_many_requests }
          format.any do
            redirect_back_or_to root_path,
                                alert: t('schematics.application.too_many_requests.alert')
          end
        end
      end
    end
  end
end
