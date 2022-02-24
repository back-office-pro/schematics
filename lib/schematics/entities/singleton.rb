# frozen_string_literal: true

module Schematics
  module Entities
    class Singleton < Entity
      def to_str
        <<~RUBY
          acts_as_singleton
          delegate :cache_key, to: :model_name

          class << self
            public :all
          end
        RUBY
      end

      protected

      def default_actions
        %w[show edit update]
      end
    end
  end
end
