# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Versions
    class Revert
      include Interactable

      delegate :version, to: :context, private: true

      before do
        @resource = version.reify(unversioned_attributes: :preserve).unstale
        @resource.paper_trail_event = :revert
      end

      def call
        fail! unless @resource.save
      end
    end
  end
end
