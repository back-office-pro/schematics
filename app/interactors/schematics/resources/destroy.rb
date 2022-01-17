# frozen_string_literal: true

module Schematics
  module Resources
    class Destroy
      include Interactable

      before do
        @resource = context.resource
      end

      def call
        fail! unless @resource.really_destroy!
      end
    end
  end
end
