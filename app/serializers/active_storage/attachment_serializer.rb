# frozen_string_literal: true

module ActiveStorage
  class AttachmentSerializer < ActiveModel::Serializer
    include Schematics::JsonSerializer
  end
end
