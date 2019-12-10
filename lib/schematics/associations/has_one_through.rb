module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      def name
        reference.name
      end

      def class_name
        name.camelize
      end

      def scope
        super + %Q[#{name} { joins(:#{entity.type}).where(#{name}: #{name}) }]
      end
    end
  end
end
