# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      include Behaviours::Searchable

      delegate :descriptor, :class_name, :preload, to: :belongs_to

      def open_api_schema_type = super
        .first
        .transform_keys(descriptor.name.to_sym => inverse_entity.descriptor.name.to_sym)

      def open_api_query_type = 'string'

      def source = belongs_to.name

      def inverse_of = through.name

      def search_column = :"#{name}_#{descriptor.name}"

      protected

      def association_to_str = super
        .chomp
        .concat(",\n")
        .concat <<~RUBY.indent(8)
          autosave: true
        RUBY

      def spec_interpolations = super.merge(entity_name: through.inverse_association_name)
    end
  end
end
