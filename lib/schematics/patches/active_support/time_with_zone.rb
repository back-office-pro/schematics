# frozen_string_literal: true

module Schematics
  module Patches
    module ActiveSupport
      module TimeWithZone
        def <=(other)
          super if other
        end

        def >=(other)
          super if other
        end

        def <(other)
          super if other
        end

        def >(other)
          super if other
        end

        def !=(other)
          super if other
        end

        def ==(other)
          super if other
        end
      end
    end
  end
end
