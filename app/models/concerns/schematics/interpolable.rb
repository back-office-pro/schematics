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
  module Interpolable
    extend ActiveSupport::Concern

    def interpolate(resource)
      suppress(Liquid::SyntaxError) do
        liquid_template.render(
          resource.serialized_json(template: 'show', expand: true),
          { strict_variables: true, strict_filters: true }
        )
      end
    end

    # :reek:UncommunicativeVariableName
    def interpolation_errors
      liquid_template.errors
    rescue Liquid::SyntaxError => e
      [e]
    end

    private

    def liquid_template
      @liquid_template ||= Liquid::Template.parse(content, error_mode: :warn)
    end
  end
end
