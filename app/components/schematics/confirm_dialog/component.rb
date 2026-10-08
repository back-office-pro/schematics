# frozen_string_literal: true

module Schematics
  module ConfirmDialog
    class Component < ApplicationComponent
      option :target
      option :text, optional: true

      def title = t('.title')

      def text
        super || t('.text')
      end
    end
  end
end
