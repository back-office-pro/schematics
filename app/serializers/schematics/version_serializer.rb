# frozen_string_literal: true

module Schematics
  class VersionSerializer < ::ActiveModel::Serializer
    attributes :id, :created_at, :event, :item, :object_changes
    # has_one :user, serializer: ::User.entity.descriptor.serializer_class

    def item = ::ActiveModelSerializers::SerializableResource.new(object.item)
  end
end
