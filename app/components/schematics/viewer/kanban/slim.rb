# frozen_string_literal: true

Schematics::Viewer::Kanban::SLIM = <<~SLIM
  .table-responsive.rounded-bottom data-controller='comparison bulk-action'
    table.table.table-borderless.mb-0
      = __filter(model_class:)
      tbody class=tbody_css_classes
        tr colspan='100%'
          - values.each do |value|
            td
              .card.kanban-card.bg-body-tertiary.shadow-sm.animate__animated.animate__zoomIn
                .card-header.p-1.text-center
                  = __card_heading(icon: :clipboard_check, title: format(value))
                .card-body.py-0 {
                  data-controller='kanban'
                  data-kanban-group-value=value
                  data-kanban-targets-value=values.excluding(value)
                  data-kanban-root-value=model_class.entity.name
                  data-kanban-attribute-value=attribute.name
                }
                  - groups[value]&.each do |resource|
                    .card.mb-3.shadow-sm.animate__animated.animate__zoomIn.cursor-grab class=card_css_class(resource) data-id=resource.id
                      .card-body.p-0
                        table.table.mb-0.table-striped.table-borderless
                          thead
                            tr
                              td colspan='2'
                                .d-inline-flex.float-end
                                  = __viewer_switch_button_group(resource:, resources:)
                                  = __viewer_action_button_group(resource:)
                            tbody
                              - elements.each do |element|
                                tr.animate__slideInRight class=col_preference_class(element)
                                  th.text-nowrap.col-4
                                    = fa_icon element.icon, class: 'me-2 text-body-secondary'
                                    = model_class.human_attribute_name(element.name)
                                  td.text-truncate
                                    = __resource_details_element(resource:, element:)
SLIM
