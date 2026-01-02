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
    class ModelField < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      delegate :depends_on, to: :options

      def available_options = super.push(
        Options::DependsOn,
        Options::Type
      )

      def collection = super.sort

      def format(value)
        return unless value

        class_name, field_name = value.split('#')
        class_name.constantize.human_attribute_name(field_name)
      rescue StandardError
        value
      end

      def icon = :code

      def validators = super.merge(inclusion: nil)

      def values = entity
        .schema
        .entities
        .reject(&:hidden?)
        .flat_map(&fields_type)
        .map(&:method_name)

      private

      def fields_type = options
        .fetch(:type, :renderable_with_created_ats_fields)
        .to_sym
    end
  end
end
