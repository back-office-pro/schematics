module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      def name
        belongs_to.name.pluralize
      end

      def class_name
        belongs_to.name.camelize
      end
    end
  end
end
