# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      delegate :descriptor, to: :belongs_to

      def source
        belongs_to.name
      end

      def class_name
        source.camelize
      end

      def search_data
        <<~RUBY
          #{name}&.to_s
        RUBY
      end

      protected

      def inverse_of
        through.name
      end
    end
  end
end
