# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Onboarding
    class Component < ApplicationComponent
      delegate :none?, to: :model_class, private: true

      def icon = :hand

      def title = t('.title')

      def model_class = current_module::Migration

      def render?
        can?(:create, model_class) && none?
      end
    end
  end
end
