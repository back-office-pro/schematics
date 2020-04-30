module Schematics
  class SearchesController < ApplicationController
    swagger_controller :searches, "Global Search"

    def create
      redirect_to search_path(query: params[:query])
    end

    swagger_api :show do |api|
      summary "Global search"
      param :path, :query, :string, :required, "Query String"
      response :success
    end

    def show
      @results = {}
      SCHEMA.entities.each do |entity|
        model_class = entity.class_name.constantize
        entity.searchable_fields.each do |field|
          records = model_class
          records = records.send(:"by_#{field.name}", params[:query])
          @results[entity.type] = (@results[entity.type] || []) + records unless records.empty?
          @results[entity.type]&.uniq!
        end
      end
      respond_to do |format|
        format.html
        format.json do
          render(json: @results.map do |type, result|
            [type, ActiveModelSerializers::SerializableResource.new(result)]
          end.to_h)
        end
      end
    end
  end
end
