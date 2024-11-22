# frozen_string_literal: true

module Schematics
  class TokensController < ApplicationController
    before_action :set_session, only: :create
    before_action :no_store, only: :create

    def create
      render json: AuthToken.new(@session)
    end

    private

    def set_session
      @session = ::Session.find_by_token_for!(:refresh_token, params.require(:refresh_token))
    end
  end
end
