# frozen_string_literal: true

module Core
  module Sessions
    class Authenticate
      include Schematics::Interactable
      delegate :resource_params, to: :context, private: true

      def call
        context.user ||= user
      end

      private

      def user = ::User.authenticate_by(email:, password:)

      def email = resource_params[:email]

      def password = resource_params[:password]
    end
  end
end
