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
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      delegate :allow_hidden?, :exclude, to: :options

      def available_options = super.push(
        Options::AllowHidden,
        Options::Exclude
      )

      def collection = super.sort

      def format(value)
        value
          &.safe_constantize
          &.human_name
          &.humanize || value
      end

      def icon = :project_diagram

      def validators = super.merge(inclusion: nil)

      def values = entity
        .schema
        .entities
        .then_tap { _1.reject(&:hidden?) unless allow_hidden? }
        .map(&:class_name)
        .excluding(exclude)
    end
  end
end
