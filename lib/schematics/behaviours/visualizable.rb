module Schematics
  module Behaviours
    module Visualizable
      def to_sql
        case field
        when Virtuals::Virtual
          field.to_sql
        when nil
          :all
        else
          field.name.to_sym
        end
      end
    end
  end
end
