# frozen_string_literal: true

module Schematics
  module Resources
    class Restore
      include Interactable
      delegate :resource, to: :context, private: true

      before { resource.paper_trail_event = :restore }

      def call
        fail! unless resource.restore(recursive: true)
      rescue ActiveRecord::RecordNotUnique => e
        fail!
      end
    end
  end
end
