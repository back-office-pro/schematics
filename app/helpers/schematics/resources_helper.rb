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
        super(resource: model_class.model_name.collection, **)
      end

      def resources_path(model_class, **)
        super(resource: model_class.model_name.collection, **)
      end

      def new_resource_path(model_class, **)
        super(resource: model_class.model_name.collection, **)
      end

      def resource_path(resource, **)
        case resource
        when Singleton
          super(resource: resource.model_name.element, **)
        else
          super(resource: resource.model_name.collection, id: resource.to_param, **)
        end
      end

      def edit_resource_path(resource, **)
        case resource
        when Singleton
          super(resource: resource.model_name.element, **)
        else
          super(resource: resource.model_name.collection, id: resource.to_param, **)
        end
      end

      def archive_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def restore_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def duplicate_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def delete_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def new_import_resource_path(model_class, **)
        super(resource: model_class.model_name.collection, **)
      end

      def import_resource_path(model_class, **)
        super(resource: model_class.model_name.collection, **)
      end

      def compare_resource_path(model_class, **)
        super(resource: model_class.model_name.collection, **)
      end

      def bulk_resource_path(model_class, **)
        super(resource: model_class.model_name.collection, **)
      end

      def autocomplete_resource_path(model_class, **)
        super(resource: model_class.model_name.collection, **)
      end

      def new_comment_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def new_emailing_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def comment_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def emailing_resource_path(resource, **)
        super(resource: resource.model_name.collection, id: resource.to_param, **)
      end

      def trigger_resource_path(resource, event, **)
        case resource
        when Singleton
          super(
            resource: resource.model_name.element,
            state: event.state_machine_name,
            event: event.name,
            **
          )
        else
          super(
            resource: resource.model_name.collection,
            id: resource.to_param,
            state: event.state_machine_name,
            event: event.name,
            **
          )
        end
      end
    end
  end
end
