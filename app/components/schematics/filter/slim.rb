# frozen_string_literal: true

Schematics::Filter::SLIM = <<~SLIM
  thead
    tr
      th.align-top.text-end.py-0 rowspan='2'
        = __viewer_settings(entity:)
        .btn-group.mt-2
          = __button_compare(model_class:)
          = __button_bulk_action(model_class:)
      - entity.listable_elements.stable_sort_by(&:weight).each do |field|
        th.text-nowrap.text-center.py-0.animate__slideInDown class=col_preference_class(field)
          = __sort_link(field:, model_class:)
    tr
      - entity.listable_elements.stable_sort_by(&:weight).each do |field|
        td.align-middle.text-center.p-1.pb-2.animate__slideInDown.overflow-visible class=col_preference_class(field)
          = __filter(:build, field:, model_class:)
SLIM
