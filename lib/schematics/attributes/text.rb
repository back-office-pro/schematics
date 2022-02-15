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
          #{name}&.to_s
        RUBY
      end

      def icon
        :text
      end

      def input_type
        :textarea
      end
    end
  end
end
