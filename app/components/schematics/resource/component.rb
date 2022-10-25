# frozen_string_literal: true

module Schematics
  module Resource
    class Component < ApplicationComponent
      option :resource
      option :field
      option :enable_buttons, default: proc { false }
      option :highlight_text, optional: true

      def enable_buttons? = enable_buttons

      def stars(rating, max_stars: 5)
        full_stars, half_stars = (rating * 2).round.divmod(2)
        ::Array
          .new(max_stars, fa_icon(:star, style: 'regular'))
          .fill(fa_icon(:star), 0, full_stars)
          .fill(fa_icon(:star_half_stroke), full_stars, half_stars)
          .join
          .html_safe # rubocop:disable Rails/OutputSafety
      end

      def value
        resource.public_send(field.name)
      end
    end
  end
end
