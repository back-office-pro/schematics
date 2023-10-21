# frozen_string_literal: true

module Schematics
  module Sudos
    class Create
      include Interactable

      delegate :current_user,
               :current_session,
               :resource_params,
               to: :context,
               private: true

      def call
        fail! unless current_user.authenticate(resource_params[:password])

        current_session.sudo!
      end
    end
  end
end
