module Schematics
  module Attributes
    class Text < Attribute
      def migration_options
        super + [:limit]
      end

      def scope
        super + %Q[#{@name} { where("#{@entity.type.pluralize}.#{@name} ILIKE ?", "%#\{#{@name}}%") }]
      end
      
      def searchable?
        true
      end
    end
  end
end
