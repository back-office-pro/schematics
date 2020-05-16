module Schematics
  module Filters
    module Range
      class BoundCell < FilterCell
        def field_tag
          :"#{type}_field_tag"
        end

        def type
          model.try(:input_type) || :number
        end

        def filter_name
          super + "[#{comparison}]"
        end

        def value
          super&.dig(comparison)
        end

        def placeholder
          I18n.t("schematics.application.filters.#{comparison}")
        end

        def unit
          model.try(:unit)
        end

        def has_unit?
          unit.present?
        end

        def date?
          type == :date
        end

        private

        def comparison
          @options[:comparison]
        end
      end
    end
  end
end
