module Schematics
  module Resources
    class Destroy
      include Interactor

      before do
        @resource = context.resource
      end

      def call
        if really?
          if @resource.really_destroy!
            context.message = ".success.destroyed"
          else
            context.fail!(message: ".failure")
          end
        elsif @resource.deleted?
          if @resource.restore(recursive: true)
            context.message = ".success.restored"
          else
            context.fail!(message: ".failure")
          end
        else
          if @resource.destroy
            context.message = ".success.archived"
          else
            context.fail!(message: ".failure")
          end
        end
      end

      private

      def really?
        context.really
      end
    end
  end
end
