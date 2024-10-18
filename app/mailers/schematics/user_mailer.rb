# frozen_string_literal: true

module Schematics
  class UserMailer < ApplicationMailer
    delegate :eager_load!, to: ::RoutesLazyRoutes, private: true
    before_action :eager_load! # TODO: remove when upgrading to Rails 8

    def new_account(user)
      @user = user
      @token = user.generate_token_for(:new_account)
      mail_to(user)
    end

    def password_reset(user)
      @user = user
      @token = user.generate_token_for(:password_reset)
      mail_to(user)
    end
  end
end
