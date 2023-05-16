# frozen_string_literal: true

module Schematics
  class DocumentationController < ApplicationController
    def show
      authorize! :index, ::ApiKey
      @documentation = ::OpenApi.generate_docs(!Rails.env.test?)
      respond_with @documentation.fetch(:open_api)
    end
  end
end
