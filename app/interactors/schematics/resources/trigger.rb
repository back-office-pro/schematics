# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class Trigger
      include Interactable

      delegate :resource, :event, to: :context, private: true
      delegate :name, :suffixed_name, to: :event, prefix: true, private: true

      before { resource.paper_trail_event = event_name.to_sym }

      def call
        fail! unless resource.public_send(:"#{event_suffixed_name}!")
      end
    end
  end
end
