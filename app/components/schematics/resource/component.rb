# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Resource
    class Component < ApplicationComponent
      option :resource
      option :element
      option :enable_buttons, default: -> { false }
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

      def code_highlight(code, language:)
        lexer = ::Rouge::Lexer.find(language)
        return code unless lexer

        ::Rouge::Formatters::HTML.new.format(lexer.new.lex(code))
      end

      def phone_country = ::Phonelib
        .parse(value)
        .valid_country
        &.downcase

      def badge_color = element
        .events
        .find { _1.to == value }
        .try(:color) || :secondary

      def value
        resource.public_send(element.name)
      end
    end
  end
end
