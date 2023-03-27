# frozen_string_literal: true

module Schematics
  module Avatar
    class Component < ApplicationComponent
      option :user

      def data = { turbo_frame: '_top' }

      def badge_css_class
        return 'bg-success' if user.online?

        'bg-danger'
      end
    end
  end
end
