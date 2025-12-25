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
  module SchemaEditor
    module Options
      module Modal
        class Component < ApplicationComponent
          delegate :object, to: :builder
          delegate :icon, :id, to: :object
          option :builder

          def available_options = object
            .available_options
            .reject(&:hidden?)
            .sort_by(&:input_type)

          def render?
            available_options.any?
          end

          def target = "schema-editor-options-modal-#{id}"

          def title = object
            .class
            .model_name
            .human
        end
      end
    end
  end
end
