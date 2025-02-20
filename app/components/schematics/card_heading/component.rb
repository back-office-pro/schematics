# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module CardHeading
    class Component < ApplicationComponent
      option :title
      option :icon, optional: true
      option :modal_title, default: -> { false }

      def css_classes = class_names(
        'text-primary',
        'text-truncate',
        'fw-bold',
        'w-100',
        'm-0': !modal?,
        'lh-lg': !modal?,
        'modal-title': modal?
      )

      def modal? = modal_title
    end
  end
end
