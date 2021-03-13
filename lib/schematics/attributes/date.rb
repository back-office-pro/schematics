require 'schematics/attributes/attribute'
require 'schematics/behaviours/listable'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'
require 'schematics/behaviours/fillable'
require 'schematics/behaviours/rangeable'

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
        validators = super
        validators[:date] = { allow_blank: !required? }
        %i[equal_to before after before_or_equal_to after_or_equal_to].each do |key|
          validators[:date][key] = @options[key].to_sym if @options.key?(key)
        end
        validators
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
    end
  end
end
