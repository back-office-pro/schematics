# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class ::Metric < Schematics::ApplicationRecord
  include Schematics::Measurable

  delegate :to_sql, :format, to: :entity_field, allow_nil: true, private: true

  def to_s
    title || I18n.t('errors.triggers.name', name: model)
  end

  memoize def value(range = period_range)
    suppress(ActiveRecord::StatementInvalid) do
      model_class
        &.preload_all
        &.where(created_at: range)
        &.public_send(aggregate.to_sym, to_sql || :all)
    end
  end

  def value_formatted
    format(value) || value || '-'
  end

  def exceeded?
    value.to_f.public_send(comparator_sign, threshold.to_f)
  end

  def trend
    value.to_f <=> value(trend_range).to_f
  end

  def trend_progress
    ((value.to_f - value(trend_range).to_f) / value(trend_range).to_f)
  end

  private

  def title
    return unless model_class

    [title_for(entity_field), period_title].compact.join(' ')
  end

  def entity_field = find_entity_field(field)

  def comparator_sign
    ActiveModel::Validations::Comparability::COMPARE_CHECKS[comparator.to_sym]
  end

  def trend_range
    2.public_send(period || :weeks).ago..1.public_send(period || :week).ago
  end
end
