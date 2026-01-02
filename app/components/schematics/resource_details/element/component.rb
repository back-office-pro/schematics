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
  module ResourceDetails
    module Element
      class Component < ApplicationComponent
        delegate :deleted?, to: :resource, private: true
        delegate :readonly?, to: :element, private: true
        option :resource
        option :element
        option :editable, default: -> { true }

        def editable?
          enable_buttons? && !(element in Attributes::Attachment)
        end

        def enable_buttons?
          editable &&
            can?(:update, resource, element.name.to_sym) &&
            (element in Behaviours::Fillable) &&
            !readonly? &&
            !deleted?
        end
      end
    end
  end
end
