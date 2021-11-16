# frozen_string_literal: true

module Schematics
  class SearchesController < ApplicationController
    def create
      redirect_to search_path(query: params[:query])
    end

    def show
      @results = {}
      @query = params[:query]
      searches = Schema.instance.entities.map do |entity|
        entity.class_name.constantize.search(
          @query,
          includes: entity.includes,
          match: :word_middle,
          suggest: true,
          misspellings: false,
          execute: false,
          scope_results: lambda do |results|
            results.accessible_by(current_ability)
          end
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
          @results.each do |_name, result|
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
  end
end
