module Schematics
  module Sessions
    class Destroy
      include Interactor

      before do
        @cookies = context.cookies
      end

      def call
        if @cookies.delete(:auth_token)
          context.message = ".success"
        else
          context.fail!(message: ".failure")
        end
      end
    end
  end
end
