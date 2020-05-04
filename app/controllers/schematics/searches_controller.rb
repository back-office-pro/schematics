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
      @query = params[:query]
      SCHEMA.entities.each do |entity|
        model_class = entity.class_name.constantize
        fields = entity.searchable_fields.map { |field| [field.search_field, @query] }.to_h
        records = model_class.ransack(fields.merge(m: 'or')).result(distinct: true)
        @results[entity.type] = (@results[entity.type] || []) + records unless records.empty?
      end
      respond_to do |format|
        format.html
        format.json do
          @results.map! do |type, result|
            [type, ActiveModelSerializers::SerializableResource.new(result)]
          end.to_h
          render json: @results
        end
      end
    end
  end
end
