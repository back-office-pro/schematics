module Schematics
  module Virtuals
    class String < Virtual
      def parse
        "\"#{super}\""
      end

      def scope
        super + %Q[#{@name} { where("CONCAT(#{concat}) ILIKE ?", "%#\{#{@name}}%") }]
      end
      
      def searchable?
        true
      end
    end
  end
end
