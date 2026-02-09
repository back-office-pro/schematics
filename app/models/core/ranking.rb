# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class ::Ranking < Schematics::ApplicationRecord
  include Schematics::Measurable

  delegate :to_sql, to: :entity_field, allow_nil: true, private: true
  delegate :name, to: :entity_field, allow_nil: true, prefix: true

  memoize def resources(ability)
    model_class
      &.preload_all
      &.accessible_by(ability)
      &.where(created_at: period_range)
      &.order(to_sql => :desc)
      &.limit(size)
  rescue ActiveRecord::StatementInvalid
    []
  end

  def to_s
    title || I18n.t('errors.triggers.name', name: model)
  end

  private

  def title
    return unless model_class

    [
      (model_class.human_attribute_name(entity_field_name) if entity_field),
      (I18n.t('of') if entity_field),
      model_class.human_name_plural,
      period_title
    ].compact.join(' ')
  end

  def entity_field = find_entity_field(field)
end
