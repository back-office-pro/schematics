# frozen_string_literal: true

module Schematics
  module Button
    module DestroyAttachment
      class Component < ApplicationComponent
        delegate :name, :record, to: :attachment
        delegate :attributes_param_key, to: :field
        option :attachment

        def field = record
          .class
          .entity
          .find_field_by_name(name)

        def url = resource_path(record)

        def target = "confirm-dialog-#{record.id}-#{attachment.id}"

        def title = t('.title')

        def render?
          can?(:destroy, attachment) && attachment in ::ActiveStorage::Attachment
        end
      end
    end
  end
end
