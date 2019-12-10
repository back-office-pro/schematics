module Schematics
  module Associations
    class HasOne < Association
      def scope
        super + %Q[#{name} { where(#{entity.type}: #{name}) }]
      end
    end
  end
end
