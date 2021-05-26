# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Update
      include Interactor

      before do
        @params = context.user_params.merge(password_reset_token: nil)
        @user = context.user
      end

      def call
        if @user.updated_at > 2.hours.ago
          if @user.update(@params)
            context.message = '.success'
          else
            context.fail!(message: '.error')
          end
        else
          context.fail!(message: '.failure')
        end
      end
    end
  end
end
