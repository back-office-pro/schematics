# frozen_string_literal: true

module Schematics
  module Resources
    class Create
      include Interactable

      before do
        @resource = context.resource
      end

      def call
        fail! unless @resource.save
      end
    end
  end
end
