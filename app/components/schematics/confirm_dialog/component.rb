# frozen_string_literal: true

module Schematics
  module ConfirmDialog
    class Component < ApplicationComponent
      def initialize(target:, text: t('schematics.application.delete.subtitle'))
        super
        @target = target
        @text = text
      end

      def label = "#{@target}-label"
    end
  end
end
