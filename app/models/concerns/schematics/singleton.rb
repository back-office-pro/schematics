# frozen_string_literal: true

module Schematics
  module Singleton
    extend ActiveSupport::Concern

    included do
      include ::Singleton
      delegate :cache_key, to: :model_name

      class << self
        public :new, :allocate

        def instance
          PaperTrail.request(enabled: false) do
            first_or_create!
          end
        end
      end
    end
  end
end
