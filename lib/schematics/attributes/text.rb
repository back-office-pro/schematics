# frozen_string_literal: true

module Schematics
  module Attributes
    class Text < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable

      def search_data
        <<~RUBY
          #{name}&.parameterize(separator: ' ')
        RUBY
      end

      def icon
        :align_justify
      end

      def input_type
        :textarea
      end

      protected

      def migration_options
        super.concat %i[default limit]
      end
    end
  end
end
