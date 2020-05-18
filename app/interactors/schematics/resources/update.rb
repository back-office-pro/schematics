module Schematics
  module Resources
    class Update
      include Interactor

      before do
        @params   = context.resource_params
        @resource = context.resource
      end

      def call
        if @resource.update(@params)
          context.message = ".success"
        else
          context.fail!(message: ".failure")
        end
      end
    end
  end
end
