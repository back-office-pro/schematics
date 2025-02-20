# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module TrixAttachment
    class Component < ResourceLinkTo::Component
      def human_name_with_icon
        case resource
        when ::User
          content_tag(:span, super, class: 'fw-bold')
        else
          super
        end
      end

      protected

      def margin_size = 1

      def icon
        case resource
        when ::User
          :at
        else
          super
        end
      end
    end
  end
end
