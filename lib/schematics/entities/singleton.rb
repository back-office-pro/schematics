# frozen_string_literal: true

module Schematics
  module Entities
    class Singleton < Entity
      def to_str
        <<~RUBY
          include ::Singleton
          delegate :cache_key, to: :model_name

          class << self
            public :allocate

            def instance
              first_or_create!
            end
          end
        RUBY
      end

      protected

      def default_actions
        %w[show update]
      end
    end
  end
end
