module Schematics
  class DashboardController < ApplicationController
    def home
    end

    def search
      @results = {}
      SCHEMA.entities.each do |entity|
        model_class = entity.type.camelize.constantize
        entity.searchable_fields.each do |field|
          records = model_class.
            includes(entity.eager_loading).
            send(:"by_#{field.name}", params[:query])
          @results[entity.type] = (@results[entity.type] || []) + records unless records.empty?
          @results[entity.type]&.uniq!
        end
        if request.format.json?
          serializable = ActiveModelSerializers::SerializableResource.new(@results[entity.type])
          @results[entity.type] = serializable
        end
      end
      respond_to do |format|
        format.html
        format.json { render json: @results }
      end
    end

    def timeline
      @versions = PaperTrail::Version.
        where('whodunnit IS NOT ?', nil).
        order(created_at: :desc).
        limit(20).
        includes(:item)
      render json: @versions
    end
  end
end
