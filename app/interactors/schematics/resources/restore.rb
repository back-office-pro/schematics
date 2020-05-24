module Schematics
  module Resources
    class Restore
      include Interactor

      before do
        @resource = context.resource
        @resource.paper_trail_event = :restore
      end

      def call
        if @resource.restore(recursive: true)
          context.message = ".success"
        else
          context.fail!(message: ".failure")
        end
      end
    end
  end
end
