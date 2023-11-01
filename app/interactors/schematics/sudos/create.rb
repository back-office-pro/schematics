# frozen_string_literal: true

module Schematics
  module Sudos
    class Create
      include Interactable

      delegate :user, :session, :resource_params, to: :context, private: true
      delegate :authenticate, to: :user, private: true
      delegate :sudo!, to: :session, private: true

      def call
        fail! unless authenticate(resource_params[:password])

        sudo!
      end
    end
  end
end
