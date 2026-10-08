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
  module ResourceForm
    module Fields
      module HasAndBelongsToMany
        class Component < BelongsTo::Component
          delegate :group_by, :filter_by, to: :field, private: true

          memoize def collection
            return super unless group_by

            model_class
              .preload_all
              .all
              .select(&filter_by)
              .group_by(&group_by)
              .to_h
              .transform_values { |value| value.map { [it.to_s, it.id] } }
              .transform_values(&:sort)
              .sort
          end

          def label = resource
            .class
            .human_attribute_name(name, count: 2)

          def control_class
            return %w[form-select] unless inline?

            %w[form-select bg-transparent]
          end

          protected

          def attribute_name = super.singularize(I18n.locale)
        end
      end
    end
  end
end
