# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Associations
    class HasManyThrough < AssociationThrough
      def source = super.pluralize

      protected

      def spec_interpolations = super.merge(entity_name: through.inverse_of)
    end
  end
end
