# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Update
      include Interactable
      delegate :user, :user_params, to: :context, private: true

      def call
        fail!(message: '.expired') unless user
        fail! unless user.update(user_params)
      end
    end
  end
end
