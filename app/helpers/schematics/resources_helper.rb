# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourcesHelper
    class << self
      def included(base)
        base.class_eval do
          include Rails.application.routes.url_helpers
          include ModuleMethods
        end
      end
    end

    module ModuleMethods
      def resources_url(model_class, **)
        super(**model_class.route_params, **)
      end

      def resources_path(model_class, **)
        super(**model_class.route_params, **)
      end

      def new_resource_path(model_class, **)
        super(**model_class.route_params, **)
      end

      def resource_path(resource, **)
        case resource
        when ActiveStorage::Attachment
          polymorphic_path(resource)
        else
          super(**resource.route_params, **)
        end
      end

      def edit_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def archive_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def restore_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def duplicate_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def delete_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def new_import_resource_path(model_class, **)
        super(**model_class.route_params, **)
      end

      def import_resource_path(model_class, **)
        super(**model_class.route_params, **)
      end

      def compare_resource_path(model_class, **)
        super(**model_class.route_params, **)
      end

      def bulk_resource_path(model_class, **)
        super(**model_class.route_params, **)
      end

      def autocomplete_resource_path(model_class, **)
        super(**model_class.route_params, **)
      end

      def new_comment_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def new_emailing_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def comment_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def emailing_resource_path(resource, **)
        super(**resource.route_params, **)
      end

      def trigger_resource_path(resource, event, **)
        super(**resource.route_params, state: event.state_machine_name, event: event.name, **)
      end
    end
  end
end
