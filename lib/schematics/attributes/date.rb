# frozen_string_literal: true

module Schematics
  module Attributes
    class Date < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable
      include Behaviours::Rangeable

      ALLOWLIST = %i[equal_to before after before_or_equal_to after_or_equal_to].freeze

      def format(value)
        value && localize(value, format: '%A %d %B %Y')
      end

      def validators
        super.merge(
          {
            date: { allow_blank: !required? }.merge(
              options
                .slice(*ALLOWLIST)
                .to_h
                .transform_values(&:to_sym)
            )
          }
        )
      end

      def default
        return ::Time.zone.today.to_s(:db) if options.before
        return ::Time.zone.tomorrow.to_s(:db) if options.after

        super
      end

      def icon
        :calendar_alt
      end

      def input_type
        :date
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
