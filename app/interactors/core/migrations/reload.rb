# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Core
  module Migrations
    class Reload
      include Schematics::Progressable

      delegate :migration, to: :context, private: true
      delegate :migrator_old_and_changed_entities,
               :migrator_changed_entities,
               to: :migration,
               private: true

      progressable migration: 75

      def call
        Rails.cache.delete('schema')
        Rails.cache.write('old_and_changed_model_classes', old_and_changed_model_classes)
        old_and_changed_model_classes
          .select(&Object.method(:const_defined?))
          .each(&Object.method(:remove_const))
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:reset_column_information)
        migrator_changed_entities
          .filter_map(&:model_class)
          .each(&:define_attribute_methods)
      end

      private

      def old_and_changed_model_classes = migrator_old_and_changed_entities
        .reject(&:existing?)
        .map(&:class_name)
        .map(&:to_sym)
    end
  end
end
