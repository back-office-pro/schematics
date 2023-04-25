# frozen_string_literal: true

module ActiveStorage
  class BlobSerializer < ActiveModel::Serializer
    include Schematics::JsonSerializer
  end
end
