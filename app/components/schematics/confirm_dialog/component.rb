# frozen_string_literal: true

module Schematics
  module ConfirmDialog
    class Component < ApplicationComponent
      def initialize(target:)
        super
        @target = target
      end

      def label = "#{@target}-label"
    end
  end
end
