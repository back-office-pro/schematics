# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class Destroy
      include Interactable
      delegate :resource, to: :context, private: true

      def call
        fail! unless resource.really_destroy!
      end
    end
  end
end
