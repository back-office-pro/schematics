# frozen_string_literal: true

Schematics::Sidebar::Item::SLIM = <<~SLIM
  li.nav-item.text-center.mw-100.mb-2
    = link_to path, class: css_classes, title:, data: do
      = fa_icon icon, size: '2x'
      .mt-2.mx-3.d-none.text-truncate class=toggled_class = human_name_plural.humanize
  = __sidebar_segment(enum_attributes, model_class: @model_class)
  li.nav-item.mb-2
SLIM
