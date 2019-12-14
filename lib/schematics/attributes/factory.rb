module Schematics
  module Attributes
    class Factory
      def self.create(entity, name:, type:, options: nil)
        "Schematics::Attributes::#{type.underscore.camelize}".constantize.new(entity, name, options)
      end
    end
  end
end
