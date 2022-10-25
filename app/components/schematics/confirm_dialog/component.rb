# frozen_string_literal: true

module Schematics
  module ConfirmDialog
    class Component < ApplicationComponent
      option :target
      option :text, default: proc { t('schematics.application.delete.subtitle') }

      def label = "#{target}-label"
    end
  end
end
