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
    module Trigger
      class Component < ApplicationComponent
        option :builder

        def collection = Schematics::Triggers::Trigger::ACTIONS
          .map { [t(it, scope: %i[activemodel attributes schematics/triggers/trigger actions]), it] } # rubocop:disable Layout/LineLength
          .sort

        def icon = :atom

        def title = t('.title')

        def prompt = t('prompt', attribute_name:)

        def data = {
          controller: 'popover schema-editor--variable-typeahead',
          'bs-trigger': 'hover',
          'bs-content': __schema_editor_trigger_popover,
          'bs-placement': 'bottom',
          'bs-html': true
        }

        private

        def attribute_name = Schematics::Triggers::Trigger
          .human_attribute_name('action')
          .downcase
      end
    end
  end
end
