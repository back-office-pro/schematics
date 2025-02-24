# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module RestoreDraft
      class Component < ApplicationComponent
        delegate :updated_at, to: :draft
        delegate :icon, to: 'current_module::Draft.entity'
        option :draft

        def title = t('.text')

        def render? = draft
          .data
          .present?
      end
    end
  end
end
