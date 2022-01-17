# frozen_string_literal: true

module Schematics
  module Sessions
    class Destroy
      include Interactable

      before do
        @cookies = context.cookies
      end

      def call
        fail! unless @cookies.delete(:auth_token)
      end
    end
  end
end
