# frozen_string_literal: true

module Schematics
  module Shortenable
    extend ActiveSupport::Concern

    included do
      has_based_uuid prefix: false, uuid_column: :id
    end

    class_methods do
      def find_by_decoded_uuid!(id)
        find ::BasedUUID.decode(id)
      rescue ::ArgumentError
        find(id)
      end
    end

    def to_param
      based_uuid&.encode(::Encoding::UTF_8) || super
    end
  end
end
