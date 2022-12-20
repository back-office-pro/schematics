# frozen_string_literal: true

module Schematics
  module ActiveStorage
    class BlobAbility < ApplicationAbility
      def initialize
        super
        cannot :read, ::ActiveStorage::Blob, filename: %w[.env master.key db.dump]
      end
    end
  end
end
