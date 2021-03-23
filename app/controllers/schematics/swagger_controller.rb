module Schematics
  class SwaggerController < ApplicationController
    def open_api
      render json: File.read(open_api_file_path)
    end

    private

    def open_api_file_path
      RspecApiDocumentation.configuration.docs_dir.join('open_api.json')
    end
  end
end
