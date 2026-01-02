# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/migration/migration_generator'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class RemoveAttribute < Command
      def generators = [migration_generator, translation_generator].compact

      def migration_generator
        case attribute
        when Behaviours::Migratable
          Rails::Generators::MigrationGenerator.new(
            ["remove_#{attribute.name}_from_#{table_name.pluralize}", attribute.to_s],
            ['--primary_key_type=string']
          )
        end
      end

      def translation_generator
        return if core?

        TranslationGenerator.new([attribute.i18n_key], [], behavior: :revoke)
      end

      def weight = 2
    end
  end
end
