# frozen_string_literal: true

module Schematics
  module Button
    module RestoreDraft
      class Component < ApplicationComponent
        delegate :updated_at, to: :current_draft

        def render?
          current_draft.present?
        end

        def icon
          ::Draft.entity.icon
        end
      end
    end
  end
end
