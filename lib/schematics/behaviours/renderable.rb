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
    end
  end
end
