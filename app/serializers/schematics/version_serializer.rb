# frozen_string_literal: true

module Schematics
  class VersionSerializer < ::ActiveModel::Serializer
    attributes :id, :created_at, :event, :item, :user, :object_changes

    def item = ::ActiveModelSerializers::SerializableResource.new(object.item)

    def user = ::ActiveModelSerializers::SerializableResource.new(
      object.user,
      serializer: ::User.entity.descriptor.serializer_class
    )
  end
end
