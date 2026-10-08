# frozen_string_literal: true

Schematics::Viewer::Map::SLIM = <<~SLIM
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
                                  .d-inline-flex.position-absolute
                                    = __viewer_switch_button_group(resource:, resources:)
                                    = __viewer_action_button_group(resource:)
                                  = __viewer_resource_link(resource:, css_classes: 'text-center') do |c|
                                    - c.with_body do
                                      = __google_map(address: resource.public_send(attribute.name))
                              tbody
                                - elements.each do |element|
                                  tr.animate__slideInRight class=col_preference_class(element)
                                    th.text-nowrap.col-4
                                      = fa_icon element.icon, class: 'me-2 text-body-secondary'
                                      = model_class.human_attribute_name(element.name)
                                    td.text-truncate
                                      = __resource_details_element(resource:, element:)
SLIM
