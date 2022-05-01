# frozen_string_literal: true

module Schematics
  class SchemaController < ApplicationController
    authorize_resource

    def edit; end

    def update
      ::JSON::Validator.validate!(Schema::SCHEMA_FILEPATH, schema_params[:data])
      File.write(Schema::APP_DATA_FILEPATH, schema_params[:data])
    end

    private

    def schema_params
      params.require(:schema).permit(:data)
    end
  end
end
