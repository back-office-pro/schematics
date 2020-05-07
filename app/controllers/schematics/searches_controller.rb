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
        fields = entity.multi_searchable_fields.map do |field|
          [:"#{field.name}_cont", @query]
        end.to_h.merge(m: 'or')
        records = model_class.ransack(fields).result(distinct: true)
        unless records.empty?
          if request.format.json?
            records = records.map do |record|
              entity.descriptor.serializer_class.new(record)
            end
          end
          (@results[entity.type.pluralize] ||= []).concat(records)
        end
      end
      respond_to do |format|
        format.html
        format.json do
          render json: @results
        end
      end
    end
  end
end
