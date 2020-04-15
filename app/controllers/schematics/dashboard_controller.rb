module Schematics
  class DashboardController < ApplicationController
    def home
    end

    def search
      @results = {}
      SCHEMA.entities.each do |entity|
        entity.searchable_fields.each do |field|
          records = entity.type.camelize.constantize.
            includes(entity.eager_loading).
            send(:"by_#{field.name}", params[:query])
          @results[entity.type] = (@results[entity.type] || []) + records unless records.empty?
          @results[entity.type]&.uniq!
        end
        if request.format.json?
          serializer = "#{entity.type.camelize}Serializer".constantize
          @results[entity.type] = ActiveModelSerializers::SerializableResource.new(
            @results[entity.type],
            each_serializer: serializer
          )
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
