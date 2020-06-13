module Schematics
  module Filters
    class FilterCell < Cell::ViewModel
      self.view_paths = ["#{Engine.root}/app/cells"]

      def name
        model.try(:name) || model
      end

      def filter_name
        "filter[#{name}]"
      end

      def value
        params.dig(:filter, name)
      end

      def active?
        value.present?
      end

      def placeholder
        I18n.t("schematics.application.filters.filter_by", attribute_name: attribute_name)
      end

      protected

      def model_class
        @options[:model_class]
      end

      def attribute_name
        model_class.human_attribute_name(name).downcase
      end
    end
  end
end
