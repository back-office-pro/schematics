# frozen_string_literal: true

module Schematics
  module Button
    module RestoreDraft
      class Component < ApplicationComponent
        delegate :updated_at, to: :current_draft
        delegate :icon, to: '::Draft.entity'

        def render?
          current_draft.present?
        end
      end
    end
  end
end
