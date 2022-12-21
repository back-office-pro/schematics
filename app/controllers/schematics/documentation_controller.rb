# frozen_string_literal: true

module Schematics
  class DocumentationController < ApplicationController
    def show
      authorize! :read, :admin_dashboard
      respond_to do |format|
        format.html
        format.json { render json: }
      end
    end

    private

    def json = ::OpenApi
      .generate_docs(!Rails.env.test?)
      .fetch(:open_api)
  end
end
