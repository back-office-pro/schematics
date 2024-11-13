# frozen_string_literal: true

module Fx
  module Override
    module Adapters
      module Postgres
        def functions
          return super if connection.adapter_name == 'PostgreSQL'

          []
        end

        def triggers
          return super if connection.adapter_name == 'PostgreSQL'

          []
        end
      end
    end
  end
end
