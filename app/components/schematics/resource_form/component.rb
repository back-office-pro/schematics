# frozen_string_literal: true

module Schematics
  module ResourceForm
    class Component < ApplicationComponent
      delegate :new_record?, to: :resource
      delegate :class, to: :resource, prefix: :model, private: true
      delegate :entity, :human_attribute_name, to: :model_class

      option :resource
      option :url, optional: true
      option :attributes, default: proc { entity.fillable_elements }
      option :cancel_path, default: proc { resource }

      def model_field_collection_class(key, field)
        'd-none' if new_record? || !key.start_with?(resource.public_send(field.depends_on))
      end

      def turbo? = request
        .headers['Turbo-Frame']
        .present?

      def wrapper
        return :edit_in_place_form if turbo?

        :input_group
      end
    end
  end
end
