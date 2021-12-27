# frozen_string_literal: true

module Schematics
  module Attributes
    class Integer < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include Behaviours::Numerable

      def open_api_type
        :integer
      end

      def validators
        validators = super
        validators[:numericality][:only_integer] = true
        validators
      end

      protected

      def migration_options
        super.concat %i[limit]
      end
    end
  end
end
