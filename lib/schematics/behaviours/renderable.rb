# frozen_string_literal: true

require 'action_view'

module Schematics
  module Behaviours
    module Renderable
      include ActionView::Helpers::TranslationHelper
      include ActionView::Helpers::NumberHelper

      def format(value)
        value
      end

      def method_name
        [entity.class_name, name].join('#')
      end

      def group_method
        :group
      end
    end
  end
end
