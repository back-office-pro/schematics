# frozen_string_literal: true

module Core
  module Sessions
    class Omniauthenticate
      include Schematics::Interactable
      delegate :resource_params, to: :context, private: true

      def call
        context.user ||= user if resource_params.is_a?(OmniAuth::AuthHash::InfoHash)
      end

      private

      def user = ::User.find_by(email:)

      def email = resource_params[:email]
    end
  end
end
