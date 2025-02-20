# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ConfirmDialog
    class Component < ApplicationComponent
      option :target
      option :text, default: -> { I18n.t('schematics.application.delete.subtitle') }

      def title = t('schematics.application.delete.title')
    end
  end
end
