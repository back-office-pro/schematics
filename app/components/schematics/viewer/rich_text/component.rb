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
  module Viewer
    module RichText
      class Component < ApplicationComponent
        delegate :icon, :entity, :name, to: :@attribute
        delegate :model_class, to: :entity
        with_collection_parameter :attribute

        def initialize(attribute:, resource:)
          super
          @attribute = attribute
          @resource = resource
        end

        def id = dom_id(@attribute)

        def render?
          value.present?
        end

        def title
          model_class.human_attribute_name(name)
        end

        def value
          @resource.public_send(name)
        end
      end
    end
  end
end
