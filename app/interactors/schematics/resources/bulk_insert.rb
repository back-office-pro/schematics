module Schematics
  module Resources
    class BulkInsert
      include Interactor
      delegate :model_name, to: :@model_class

      before do
        @file = context.file # TODO validate content_type CSV
        @model_class = context.model_class
        @errors = {}
      end

      def call
        CSV.foreach(@file, headers: true).with_index(1) do |row, line|
          row = row.to_h.transform_keys(&method(:get_attribute))#.transform_values(&method(:get_value))
          resource = @model_class.new(row)
          resource.paper_trail_event = :import
          result = Create.call(resource: resource)
          next if result.success?
          @errors[line] = resource.errors
        #rescue ActiveModel::UnknownAttributeError => e
        #  @errors[line] = [e.message]
        rescue e
          @errors[line] = [e.message]
        end
        if @errors.empty?
          context.message = ".success"
        else
          context.errors = @errors
          context.fail!(message: ".failure")
        end
      end

      private

      def get_attribute(key)
        i18n_attributes[key] || key.parameterize(separator: '_').to_sym
      end

      def get_value(value)
        puts I18n.t(model_name.to_s.underscore.to_sym, scope: '.activerecord.attributes').key?(value.pluralize.to_sym)
        return value unless I18n.t(model_name.to_s.underscore.to_sym, scope: '.activerecord.attributes').key?(value.pluralize.to_sym)
        v = I18n.t([model_name.to_s.underscore, value.pluralize], scope: '.activerecord.attributes').invert
        v[value]
      end

      def i18n_values
        return {} unless I18n.t('.activerecord.attributes').key?(model_name.to_s.underscore.to_sym)
        I18n.t(model_name.to_s.underscore, scope: '.activerecord.attributes').invert
      end

      def i18n_attributes
        return {} unless I18n.t('.activerecord.attributes').key?(model_name.to_s.underscore.to_sym)
        I18n.t(model_name.to_s.underscore, scope: '.activerecord.attributes').invert
      end
    end
  end
end
