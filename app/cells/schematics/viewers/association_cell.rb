module Schematics
  module Viewers
    class AssociationCell < ViewerCell
      delegate :entity, to: :model_class
      delegate :icon, to: :entity
      alias resources model

      def title
        model_class.human_attribute_name(entity.name, count: resources.size)
      end

      def random
        SecureRandom.base58
      end

      def collapsed
        @options[:collapsed] || false
      end

      def model_class
        resources.first.class
      end
    end
  end
end
