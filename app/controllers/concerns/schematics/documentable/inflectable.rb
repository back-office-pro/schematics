# frozen_string_literal: true

module Schematics
  module Documentable
    module Inflectable
      extend ActiveSupport::Concern

      included do
        api_dry :all do
          header 'x-api-inflection',
                 ::String,
                 desc: 'Inflect payload keys. Possible values are camel, dash, snake or pascal.'
        end
      end
    end
  end
end
