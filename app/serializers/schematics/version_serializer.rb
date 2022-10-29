# frozen_string_literal: true

module Schematics
  class VersionSerializer < ::ActiveModel::Serializer
    attributes :id, :created_at, :event, :user, :item, :object_changes

    def user = ::ActiveModelSerializers::SerializableResource.new(object.user)

    def item = ::ActiveModelSerializers::SerializableResource.new(object.item)
  end
end
