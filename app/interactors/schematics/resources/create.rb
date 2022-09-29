# frozen_string_literal: true

module Schematics
  module Resources
    class Create
      include Interactable
      delegate :resource, to: :context, private: true

      def call
        fail! unless resource.save
      end
    end
  end
end
