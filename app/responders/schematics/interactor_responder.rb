# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  # :reek:ManualDispatch :reek:ModuleInitialize
  module InteractorResponder
    delegate :t, to: :controller, private: true
    delegate :message, to: :resource, private: true

    def initialize(controller, resources, options = {})
      super
      return unless interactor?

      @flash_interpolation_options = options.delete(:flash_interpolation_options)
      @notice = t(message, **mount_i18n_options(:notice))
      @alert = t(message, **mount_i18n_options(:alert))
      @redirect_on_failure = options.delete(:redirect_on_failure) { false }
    end

    def display_errors
      return super unless @redirect_on_failure

      redirect_to navigation_location, status: redirect_status
    end

    def display(resource, given_options = {})
      return super unless interactor?

      super(resource.resource, given_options)
    end

    def has_errors? # rubocop:disable Naming/PredicateName
      return super unless interactor?

      resource.failure?
    end

    def resource_errors
      return super unless interactor?
      return __send__(:"#{format}_resource_errors") if respond_to?(:"#{format}_resource_errors")

      errors
    end

    def json_resource_errors
      return super unless interactor?

      { errors: }
    end

    def controller_interpolation_options
      (super || {}).merge(@flash_interpolation_options || {})
    end

    protected

    def interactor?
      resource in ::Interactor::Context
    end

    def errors = [t(resource.message)]
  end
end
