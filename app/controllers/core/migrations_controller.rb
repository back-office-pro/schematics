# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class MigrationsController < Schematics::ResourcesController
  def new
    super && edit
  end

  def edit
    @resource.prompt ||= model_class.default_prompt
  end

  private

  def permitted_params = super << {
    entities_attributes: [
      [
        :id,
        :name,
        [options_attributes: [:icon, :descriptor, [actions: []]]],
        [attributes_attributes: [[:id, :name, :type, { options_attributes: {} }]]],
        [virtuals_attributes: [[:id, :name, :function, { options_attributes: {} }]]],
        [has_and_belongs_to_many_associations_attributes: [[:name, :type, { options_attributes: {} }]]], # rubocop:disable Layout/LineLength
        [triggers_attributes: [%i[id action callback]]]
      ]
    ]
  }

  def resource_params
    return super if super.key?(permitted_params.first)

    Core::MigrationMapper.new.call(super.to_h)
  end
end
