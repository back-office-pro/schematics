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
  module Viewer
    module Specifications
      module Section
        class Component < ApplicationComponent
          with_collection_parameter :element

          def initialize(element:, indent: 0, options: false, icon: nil, item_class: nil)
            super
            @element = element
            @indent = indent
            @options = options
            @icon = icon || element.icon
            @item_class = item_class
          end

          def interpolate(element)
            element
              .to_spec
              .gsub(/\*\*(.*?)\*\*/, '<b>\1</b>')
              .gsub(/\*(.*?)\*/, '<i>\1</i>')
              .gsub(/`(.+)`/, '<code>\1</code>')
          end
        end
      end
    end
  end
end
