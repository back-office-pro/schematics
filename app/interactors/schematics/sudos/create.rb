# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Sudos
    class Create
      include Interactable

      delegate :user, :session, :resource_params, to: :context, private: true
      delegate :authenticate, to: :user, private: true
      delegate :sudo!, to: :session, private: true

      def call
        fail! unless authenticate(password)

        sudo!
      end

      private

      def password = resource_params[:password]
    end
  end
end
