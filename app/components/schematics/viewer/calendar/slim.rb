# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Viewer::Calendar::SLIM = <<~SLIM
  .table-responsive.rounded-bottom data-controller='comparison bulk-action'
    table.table.table-borderless.mb-0
      = __filter(model_class:)
      tbody
        table.table.table-borderless.table-striped-columns.mb-0
          thead
            tr
              - date_range.slice(0, 7).each do |day|
                th.text-center = t('date.day_names')[day.wday]
          tbody class=tbody_css_classes
            - date_range.each_slice(7) do |week|
              tr
                - week.each do |date|
                  td.calendar-day.p-0 class=td_class_for(date)
                    .text-body-secondary.ps-2.pt-1 = date.day
                    - resources_for(date).each do |resource|
                      = __viewer_resource_link(resource:, css_classes: alert_css_classes_for(resource, date)) do |c|
                        - c.with_body do
                          - unless previous_resource_for?(resource, date)
                            .d-inline-flex
                              = __viewer_switch_button_group(resource:, resources:)
                              = __viewer_action_button_group(resource:)
                          span.ms-2.lh-lg = resource
SLIM
