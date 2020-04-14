module Schematics
  module Behaviours
    module Fillable
      def permitted_param
        column_name
      end

      def permitted_json_param
        permitted_param
      end
    end
  end
end
