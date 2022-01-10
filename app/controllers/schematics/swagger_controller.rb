# frozen_string_literal: true

module Schematics
  class SwaggerController < ApplicationController
    def index; end

    def show
      render json: File.read(open_api_file_path)
    end

    private

    def open_api_file_path
      File.join(OpenApi::Config.file_output_path, 'open_api.json')
    end
  end
end
