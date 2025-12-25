# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module ThemeCustomStylesheet
    class Component < ApplicationComponent
      delegate :theme_color, to: '::Configuration'

      def theme_color_darken = theme_color
        .paint
        .darken(12)
        .to_s

      def theme_color_darken_rgb = theme_color_darken
        .paint
        .to_rgb
        .scan(/\d+/)
        .join(', ')

      def theme_color_rgb = theme_color
        .paint
        .to_rgb
        .scan(/\d+/)
        .join(', ')
    end
  end
end
