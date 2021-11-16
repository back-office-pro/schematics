# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Routing
      extend ActiveSupport::Concern

      included do
        # TODO
      end

      class_methods do
        delegate :entity, to: :model_class, private: true

        def model_class
          name.demodulize.split('_').first.constantize
        end
      end
    end
  end
end
