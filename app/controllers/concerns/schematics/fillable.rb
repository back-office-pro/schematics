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
  module Fillable
    extend ActiveSupport::Concern

    delegate :entity, to: :model_class, private: true

    def resource_params
      params.expect(entity.name.to_sym => permitted_params.excluding(disallowed_params))
    end

    def resource_params_with_defaults
      resource_params.merge(resource_defaults.compact)
    end

    private

    def permitted_params
      return entity.permitted_json_params if request.format.json?

      entity.permitted_params
    end

    def disallowed_params
      current_ability.disallowed_params(action_name.to_sym, @resource || model_class)
    end

    def resource_defaults = entity
      .user_attributes
      .to_h { |attribute| [attribute.column_name, current_user.id] }
  end
end
