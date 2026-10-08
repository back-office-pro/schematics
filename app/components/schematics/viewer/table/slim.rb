# frozen_string_literal: true

Schematics::Viewer::Table::SLIM = <<~SLIM
  .table-responsive.rounded-bottom data-controller='comparison bulk-action'
    table.table.table-borderless.mb-0 class=table_css_classes
      = __filter(model_class:)
      tbody class=tbody_css_classes
        - if resources.empty?
          tr
            td.pt-4 colspan='100%'
              = __empty_resource
        - else
          - resources.each do |resource|
            = __viewer_resource_link(resource:, tag_name: :tr) do |c|
              - c.with_body do
                td.col-1.text-nowrap.px-2.py-0.align-middle.start-0.sticky-top
                  .d-inline-flex
                    = __viewer_switch_button_group(resource:, resources:)
                    = __viewer_action_button_group(resource:)
                - elements.each do |element|
                  td.col-2.text-truncate.text-center.align-middle.animate__slideInDown class=col_preference_class(element)
                    = __resource_details_element(resource:, element:)
SLIM
