# frozen_string_literal: true

module Core
  module Sessions
    class Impersonate
      include Schematics::Interactable
      delegate :can?, to: :ability, private: true
      delegate :ability, :resource_params, to: :context, private: true

      def call
        context.user ||= user if can?(:impersonate, user)
      end

      private

      memoize def user = ::User.find_by(email:)

      def email = resource_params[:email]
    end
  end
end
