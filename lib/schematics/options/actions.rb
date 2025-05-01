# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    # :reek:InstanceVariableAssumption
    class Actions < CollectionOption
      include ::ActionView::Helpers::TranslationHelper

      def multiple? = true

      def collection = @collection
        .map { [translate(_1, scope: %i[activerecord enums permission action]), _1] }
        .sort
    end
  end
end
