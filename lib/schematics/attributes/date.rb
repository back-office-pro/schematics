module Schematics
  module Attributes
    class Date < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable

      def migration_options
        super + [:before, :after]
      end

      def format(value)
        value && I18n.l(value, format: "%A %d %B %Y")
      end

      def validators
        validators = super
        validators[:date] = { allow_blank: !required? }
        [:equal_to, :before, :after, :before_or_equal_to, :after_or_equal_to].each do |key|
          validators[:date][key] = @options[key].to_sym if @options.key?(key)
        end
        validators
      end

      def icon
        :calendar_alt
      end

      def input_type
        :date
      end
    end
  end
end
