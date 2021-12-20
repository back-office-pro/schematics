# frozen_string_literal: true

module Schematics
  module Versions
    class Revert
      include Interactor

      before do
        @version = context.version
      end

      def call
        if @version.reify&.unstale&.save || @version.item.really_destroy!
          context.message = '.success'
        else
          context.fail!(message: '.failure')
        end
      end
    end
  end
end
