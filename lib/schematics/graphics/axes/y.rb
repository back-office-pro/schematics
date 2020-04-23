module Schematics
  module Graphics
    module Axes
      class Y < Axis
        def title
          super.push(
            I18n.t('schematics.dashboard.home.graphics.of'),
            model_class.model_name.human.downcase.pluralize
          ).join(' ')
        end
      end
    end
  end
end
