module Schematics
  module SortLink
    class Component < ApplicationComponent
      delegate :name, to: :@field

      def initialize(field:, model_class:)
        super
        @field = field
        @model_class = model_class
      end

      def icon
        return :sort_down if asc?
        return :sort_up   if desc?
        @field.icon
      end

      def icon_text_class
        return :danger  if asc?
        return :success if desc?
        :dark
      end

      def link_params
        request.parameters.merge(sort: new_sorted_params)
      end

      def attribute_name
        @model_class.human_attribute_name(name)
      end

      private

      def sorted_params
        params[:sort]&.split(',')
      end

      def new_sorted_params
        return name unless sorted_params
        new_params = revert_sorted_params
        new_params << name if new_param?
        new_params.join(',')
      end

      def revert_sorted_params
        sorted_params.map do |sorted_param|
          next "-#{name}" if sorted_param == name
          next name if sorted_param == "-#{name}"
          sorted_param
        end
      end

      def new_param?
        !asc? && !desc?
      end

      def asc?
        sorted_params&.include?(name)
      end

      def desc?
        sorted_params&.include?("-#{name}")
      end
    end
  end
end
