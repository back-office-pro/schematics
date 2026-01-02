# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::PreferencesTable::SLIM = <<~SLIM
  = form_with url: preferences_path, method: :patch do
    .table-responsive
      table.table.mb-0.table-striped.table-borderless
        thead
          tr
            th
            - events.each_value do |action|
              th.text-primary.pt-0 = action
        tbody
          - model_classes.each do |model_class|
            tr
              td.text-nowrap
                = fa_icon model_class.entity.icon, class: 'me-2 text-body-secondary'
                = model_class.human_name_plural.humanize
              - events.each_key do |action|
                td
                  = __preferences_table_toggle(action:, model_class:)
    .m-3
      = __button_confirm
      = __button_cancel(path: root_path)
SLIM
