# frozen_string_literal: true

module Schematics
  module Avatar
    class Component < ApplicationComponent
      def initialize(user:)
        super
        @user = user
      end

      def title
        @user.full_name
      end

      def badge_css_class
        return 'badge-success' if @user.online?

        'badge-danger'
      end
    end
  end
end
