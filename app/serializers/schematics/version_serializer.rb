# frozen_string_literal: true

module Schematics
  class VersionSerializer < ::ActiveModel::Serializer
    attributes :id, :created_at, :event, :item, :object_changes
    has_one :user

    class << self
      # :reek:ControlParameter
      def serializer_for(model, *)
        case model
        when User
          ::User.entity.descriptor.serializer_class
        else
          super
        end
      end
    end

    def item = ::ActiveModelSerializers::SerializableResource.new(object.item)
  end
end
