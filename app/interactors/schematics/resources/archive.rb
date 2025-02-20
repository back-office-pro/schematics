# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class Archive
      include Interactable
      delegate :resource, to: :context, private: true

      before { resource.paper_trail_event = :archive }

      def call
        fail! unless resource.destroy
      end
    end
  end
end
