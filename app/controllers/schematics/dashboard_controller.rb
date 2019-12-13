module Schematics
  class DashboardController < ApplicationController
    def home
    end

    def search
      @results = {}
      SCHEMA.entities.each do |entity|
        entity.attributes.select_is_a?(Schematics::Attributes::Text).reject_is_a?(Schematics::Attributes::Digest).each do |attribute|
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

    def timeline
      @versions = PaperTrail::Version.where('whodunnit IS NOT ?', nil).order(created_at: :desc).limit(20).includes(:item)
      render json: @versions
    end
  end
end
