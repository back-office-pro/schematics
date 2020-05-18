module Schematics
  module Resources
    class Create
      include Interactor

      before do
        @resource = context.resource
      end

      def call
        if @resource.save
          context.message = ".success"
        else
          context.fail!(message: ".failure")
        end
      end
    end
  end
end
