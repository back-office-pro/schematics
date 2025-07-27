# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class Duplicate
      include Interactable

      delegate :resource, to: :context, private: true

      before { resource.paper_trail_event = :duplicate }

      def call
        fail! unless resource.save
      rescue ActiveRecord::RecordNotUnique
        fail!
      end
    end
  end
end
