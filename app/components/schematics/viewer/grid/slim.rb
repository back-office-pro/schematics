# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Viewer::Grid::SLIM = <<~SLIM
  .table-responsive.rounded-bottom data-controller='comparison bulk-action'
    table.table.table-borderless.mb-0
      = __filter(model_class:)
      tbody class=tbody_css_classes
        tr
        - if resources.empty?
          td.pt-4 colspan='100%'
            = __empty_resource
        - else
            td.p-0 colspan='100%'
              - groups.each do |group|
                .row.g-0
                  - group.each do |resource|
                    .col-xl-4.col-md-6
                      .card
                        .card-body.p-0
                          table.table.mb-0.table-striped.table-borderless
                            thead
                              tr
                                td colspan='2'
                                  .d-inline-flex.position-absolute.z-1
                                    = __viewer_switch_button_group(resource:, resources:)
                                    = __viewer_action_button_group(resource:)
                                  = __viewer_grid_carousel(resource:)
                              tbody
                                - elements.each do |element|
                                  tr.animate__slideInRight class=col_preference_class(element)
                                    th.text-nowrap.col-4
                                      = fa_icon element.icon, class: 'me-2 text-body-secondary'
                                      = model_class.human_attribute_name(element.name)
                                    td.text-truncate
                                      = __resource_details_element(resource:, element:)
SLIM
