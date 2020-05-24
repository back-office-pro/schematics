module Schematics
  module Resources
    class Archive
      include Interactor

      before do
        @resource = context.resource
      end

      def call
        if @resource.destroy
          context.message = ".success"
        else
          context.fail!(message: ".failure")
        end
      end
    end
  end
end
