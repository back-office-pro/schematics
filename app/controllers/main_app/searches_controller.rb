# frozen_string_literal: true

module MainApp
  module SearchesController
    extend ActiveSupport::Concern

    prepended do
      after_action -> { flash.clear }
    end

    def show # rubocop:disable Metrics/CyclomaticComplexity
      searches = Schematics::Schema.instance.entities.reject(&:hidden?).map do |entity|
        entity.model_class.search(
          @resource.query,
          includes: entity.includes,
          match: :word_middle,
          suggest: true,
          misspellings: false,
          scope_results: -> { _1.accessible_by(current_ability) }
        )
      end
      @results = Searchkick.multi_search(searches)
      @suggestions = @results.flat_map(&:suggestions).uniq
      @results = @results.flat_map(&:results).group_by do |record|
        record.class.entity.name.pluralize
      end
      respond_to do |format|
        format.html
        format.json do
          @results.each_value do |result|
            result.map! do |record|
              {
                icon: record.class.entity.icon.to_s.dasherize,
                data: record.class.entity.descriptor.serializer_class.new(record),
                descriptor: record.class.entity.descriptor.name,
                url: main_app.polymorphic_path(record)
              }
            end
          end
          render json: @results
        end
      end
    end

    protected

    def set_resource
      super
    rescue ActiveRecord::RecordNotFound
      @resource = model_class.new(query: params[:id])
    end
  end
end
