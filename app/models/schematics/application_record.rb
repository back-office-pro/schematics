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
  class ApplicationRecord < ::ActiveRecord::Base
    primary_abstract_class

    self.implicit_order_column = 'created_at'
    self.inheritance_column = nil

    include Loadable
    include Duplicable
    include Serializable
    include Identifiable
    include Translatable
    include Mentionable
    include Previewable
    include Attachable
    include Routable

    loadable concerns: [
      SoftDeletable,
      Multisearchable,
      Searchable,
      Trackable,
      Sluggable
    ]
  end
end
