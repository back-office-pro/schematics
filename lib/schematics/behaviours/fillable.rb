module Schematics
  module Behaviours
    module Fillable
      def permitted_params
        column_name
      end

      def permitted_json_params
        permitted_params
      end
    end
  end
end
