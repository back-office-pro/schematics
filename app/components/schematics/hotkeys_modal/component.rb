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
  module HotkeysModal
    class Component < ApplicationComponent
      ALPHABET = [*'1'..'9', *'a'..'z']
        .without('h', 's')
        .freeze

      def icon = :keyboard

      def title = t('.title')

      def groups = SchemaCache
        .model_classes
        .reject(&:abstract?)
        .push(::Import, ::ActiveStorage::Blob, ::Emailing)
        .select { can?(:index, it) }
        .sort_by(&:human_name)
        .map
        .with_index { |klass, index| [ALPHABET[index], klass.human_name_plural.humanize] }
        .push(['h', t('.home')], ['s', t('.search')])
        .sort_by(&:first)
        .in_groups_of(2, false)
    end
  end
end
