# frozen_string_literal: true

module Schematics
  # :reek:ManualDispatch :reek:ModuleInitialize
  module InteractorResponder
    def initialize(controller, resources, options = {})
      super
      return unless interactor?

      @notice = t(resource.message, **mount_i18n_options(:notice))
      @alert = t(resource.message, **mount_i18n_options(:alert))
      @redirect_on_failure = options.delete(:redirect_on_failure) { false }
    end

    def display_errors
      return super unless @redirect_on_failure

      redirect_to navigation_location, status: redirect_status
    end

    def display(resource, given_options = {})
      return super unless interactor?

      super resource.resource, given_options
    end

    def has_errors? # rubocop:disable Naming/PredicateName
      return super unless interactor?

      resource.failure?
    end

    def resource_errors
      return super unless interactor?
      return __send__("#{format}_resource_errors") if respond_to?("#{format}_resource_errors")

      controller_errors
    end

    def json_resource_errors
      return super unless interactor?

      { errors: controller_errors }
    end

    private

    def interactor?
      resource.is_a?(::Interactor::Context)
    end

    def t(message, **kwargs)
      case controller
      when ResourcesController
        controller.tscope(message, **kwargs)
      else
        controller.translate(message, **kwargs)
      end
    end

    def controller_errors
      case controller
      when ResourcesController
        resource.resource.errors
      else
        [t(resource.message)]
      end
    end
  end
end
