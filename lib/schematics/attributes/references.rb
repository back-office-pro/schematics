module Schematics
  module Attributes
    class References < Association
      def association_type
        "user" # by convention, this attribute will always be set to current_user
      end
    end
  end
end
