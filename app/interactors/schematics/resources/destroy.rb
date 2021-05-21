# frozen_string_literal: true

module Schematics
  module Resources
    class Destroy
      include Interactor

      before do
        @resource = context.resource
      end

      def call
        if @resource.really_destroy!
          context.message = '.success'
        else
          context.fail!(message: '.failure')
        end
      end
    end
  end
end
