# frozen_string_literal: true

module Schematics
  module Themeable
    extend ActiveSupport::Concern

    included do
      before_action :set_chart_colors
    end

    def set_chart_colors
      Chartkick.options[:colors] = helpers
                                   .settings(:theme_color)
                                   .paint
                                   .darken(helpers.preferences(:theme) == 'dark' ? 5 : 0)
                                   .palette
                                   .analogous(as: :hex)
    end
  end
end
