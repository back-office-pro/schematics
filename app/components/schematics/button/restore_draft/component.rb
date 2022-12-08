# frozen_string_literal: true

module Schematics
  module Button
    module RestoreDraft
      class Component < ApplicationComponent
        delegate :updated_at, to: :draft
        delegate :icon, to: 'mod::Draft.entity'
        option :draft

        def render?
          draft.present?
        end
      end
    end
  end
end
