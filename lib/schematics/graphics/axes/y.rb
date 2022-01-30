# frozen_string_literal: true

module Schematics
  module Graphics
    module Axes
      class Y < Axis
        def title
          super.push(
            I18n.t('schematics.dashboard.home.graphics.of'),
            model_class.human_name_plural
          ).join(' ')
        end
      end
    end
  end
end
