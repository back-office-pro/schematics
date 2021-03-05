module Schematics
  class DashboardController < ApplicationController
    def home
    end

    def chart
      render json: SCHEMA.charts[params[:id].to_i - 1]
    end

    def open_api
      render json: File.read(open_api_file_path)
    end

    private

    def open_api_file_path
      RspecApiDocumentation.configuration.docs_dir.join('open_api.json')
    end
  end
end
