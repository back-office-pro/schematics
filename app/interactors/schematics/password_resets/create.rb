# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Create
      include Interactable
      delegate :email, to: :context, private: true
      delegate :current_shard, to: :user, private: true

      def call
        return unless user

        UserMailer
          .with(shard: current_shard)
          .password_reset(user.id)
          .deliver_later
      end

      private

      def user = ::User.find_by(email:)
    end
  end
end
