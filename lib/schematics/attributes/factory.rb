module Schematics
  module Attributes
    class Factory
      def self.create(entity, name:, type:, options: nil, renderer: nil)
        "Schematics::Attributes::#{type.underscore.camelize}".constantize.new(entity, name, options, renderer)
      end
    end
  end
end
