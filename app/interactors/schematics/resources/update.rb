# frozen_string_literal: true

module Schematics
  module Resources
    class Update
      include Interactable
      delegate :resource, :resource_params, to: :context, private: true

      def call
        fail! unless resource.update(resource_params)
      end
    end
  end
end
