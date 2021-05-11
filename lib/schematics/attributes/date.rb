require 'schematics/attributes/attribute'
require 'schematics/behaviours/listable'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'
require 'schematics/behaviours/fillable'
require 'schematics/behaviours/rangeable'
require 'schematics/behaviours/editable'

module Schematics
  module Attributes
    class Date < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable
      include Behaviours::Rangeable

      def format(value)
        value && I18n.l(value, format: '%A %d %B %Y')
      end

      def validators
        super.merge(
          {
            date: {
              allow_blank: !required?,
              equal_to: @options[:equal_to]&.to_sym,
              before: @options[:before]&.to_sym,
              after: @options[:after]&.to_sym,
              before_or_equal_to: @options[:before_or_equal_to]&.to_sym,
              after_or_equal_to: @options[:after_or_equal_to]&.to_sym,
            }.compact,
          }.compact_blank
        )
      end

      def default
        return ::Time.zone.today.to_s(:db) if @options.key?(:before)
        return ::Time.zone.tomorrow.to_s(:db) if @options.key?(:after)
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
