# frozen_string_literal: true

module Schematics
  module Avatar
    class Component < ApplicationComponent
      option :user
      option :width, optional: true
      option :height, optional: true
      option :size, optional: true

      def kwargs
        { width:, height:, size: }.compact
      end

      def badge_css_class
        return 'bg-success' if user.online?

        'bg-danger'
      end
    end
  end
end
