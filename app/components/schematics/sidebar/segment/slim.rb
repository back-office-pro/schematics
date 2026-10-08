# frozen_string_literal: true

Schematics::Sidebar::Segment::SLIM = <<~SLIM
  li.nav-item.text-center.mw-100.mb-2.px-3.d-none.segment class=toggled_class
    ul.list-group
      - values.each do |value|
        = link_to path(value), class: css_classes(value) do
          li.list-group-item.list-group-item-action.d-flex.justify-content-between.align-items-center.px-2.py-1.bg-transparent
            span.text-secondary.text-truncate = format(value)
            span.badge.bg-secondary.text-primary.ms-2 = @model_class.public_send(:"\#{@attribute.name}_\#{value}").count
SLIM
