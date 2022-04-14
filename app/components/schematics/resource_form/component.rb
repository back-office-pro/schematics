# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :new_record?, to: :@resource
      delegate :class, to: :@resource, prefix: :model, private: true
      delegate :entity, :human_attribute_name, to: :model_class

      def initialize(resource:, url: nil, remote: false, attributes: nil, cancel_path: nil)
        super
        @resource = resource
        @url = url
        @remote = remote
        @attributes = attributes || entity.fillable_elements
        @cancel_path = cancel_path || resource
      end

      def model_field_collection_class(key, field)
        'd-none' if new_record? || !key.start_with?(@resource.public_send(field.depends_on))
      end

      def remote?
        @remote
      end

      def data
        {
          controller: 'form',
          'auto-save-target': 'form',
          'edit-in-place-target': 'form',
          type: :json
        }
      end

      def cancel_button_data
        return unless remote?

        { action: 'click->edit-in-place#toggle' }
      end

      def css_classes
        'd-none d-flex' if remote?
      end

      def wrapper
        return :input_group unless remote?

        :edit_in_place_form
      end
    end
  end
end
