# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class Update
      include Interactable

      delegate :resource, :resource_params, :draft, to: :context, private: true
      delegate :really_destroy!,
               to: 'draft&.unstale',
               allow_nil: true,
               prefix: :draft,
               private: true

      after :draft_really_destroy!

      def call
        fail! unless resource.update(resource_params)
      end
    end
  end
end
