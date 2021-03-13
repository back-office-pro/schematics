module Schematics
  module Behaviours
    module Fillable
      def permitted_params
        column_name.to_sym
      end

      def permitted_json_params
        permitted_params
      end

      def default
        nil
      end

      def json_default
        default
      end
    end
  end
end
