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
  module SchemaEditor
    module Button
      module AddDropdown
        class Component < ApplicationComponent
          delegate :index, to: :builder
          option :builder

          def most_used_collection = [
            Attributes::Attachment,
            Attributes::Boolean,
            Attributes::Date,
            Attributes::StateMachine,
            Attributes::Integer,
            Attributes::String,
            Attributes::Text
          ].sort_by { it.model_name.human }

          def advanced_collection = Attributes::Attribute
            .collection
            .excluding(
              Attributes::BelongsTo,
              Attributes::User,
              most_used_collection
            )
            .sort_by { it.model_name.human }

          def title = t('.title')

          def entity = builder.object
        end
      end
    end
  end
end
