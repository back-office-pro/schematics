# frozen_string_literal: true

module Schematics
  module Resources
    class Update
      include Interactable

      before do
        @params = context.resource_params
        @resource = context.resource
      end

      def call
        fail! unless @resource.update(@params)
      end
    end
  end
end
