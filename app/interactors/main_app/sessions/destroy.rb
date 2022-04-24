# frozen_string_literal: true

module MainApp
  module Sessions
    class Destroy
      include Schematics::Interactable

      before do
        @session = context.current_session
        @cookies = context.cookies
      end

      def call
        fail! unless @session.destroy && @cookies.delete(:auth_token)
      end
    end
  end
end
