# frozen_string_literal: true

module Schematics
  module Button
    module RestoreDraft
      class Component < ApplicationComponent
        delegate :updated_at, to: :current_draft

        def icon
          ::Draft.entity.icon
        end

        def render?
          current_draft.present?
        end
      end
    end
  end
end
