# frozen_string_literal: true

require 'action_view'

module Schematics
  module Options
    # :reek:InstanceVariableAssumption
    class Actions < CollectionOption
      include ::ActionView::Helpers::TranslationHelper

      def multiple? = true

      def collection = @collection
        .map { [translate(it, scope: %i[activerecord enums permission action]), it] }
        .sort
    end
  end
end
