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
  module Measurable
    extend ActiveSupport::Concern

    included do
      delegate :entity, to: :model_class, allow_nil: true, private: true
      delegate :find_field_by_name, to: :entity, allow_nil: true, private: true
    end

    def model_class
      model.safe_constantize
    end

    def icon
      entity&.icon || :triangle_exclamation
    end

    protected

    def period_range
      return ..Time.current unless period

      1.public_send(period).ago..
    end

    def period_title
      return unless period

      [I18n.t('since'), period_formatted.downcase].join(' ')
    end

    def title_for(field)
      return unless model_class

      [
        aggregate_formatted,
        I18n.t('of'),
        (model_class.human_attribute_name(field.name).pluralize(I18n.locale).downcase if field),
        (I18n.t('of') if field),
        model_class.human_name_plural
      ].compact.join(' ')
    end

    def find_entity_field(field)
      field && find_field_by_name(field.split('#').last)
    end
  end
end
