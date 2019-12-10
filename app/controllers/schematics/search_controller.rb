module Schematics
  class SearchController < ::ApplicationController
    layout "schematics/application"
    helper Schematics::ApplicationHelper

    def query
      @results = {}
      SCHEMA.entities.each do |entity|
        entity.attributes.select_is_a?(Schematics::Attributes::Text).each do |attribute|
          records = entity.type.camelize.constantize.send("by_#{attribute.name}", params[:query])
          @results[entity.type] = (@results[entity.type] || []) + records unless records.empty?
        end
        #@results[entity.name].map! { |result| Schematics::Serializers::JSON.new(SCHEMA, entity).serialize(result) }.uniq! unless @results[entity.name].nil?
        @results[entity.type].uniq! unless @results[entity.type].nil?
      end
      respond_to do |format|
        format.html
        format.json { render json: @results }
      end
    end
  end
end
