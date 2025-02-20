# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class Create
      include Interactable
      delegate :resource, :draft, to: :context, private: true
      delegate :really_destroy!, to: :draft, allow_nil: true, prefix: true, private: true

      after :draft_really_destroy!

      def call
        fail! unless resource.save
      end
    end
  end
end
