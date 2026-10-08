# frozen_string_literal: true

Schematics::Button::BulkAction::SLIM = <<~SLIM
  button.btn.text-danger.btn-sm.pe-1.d-none {
    data-controller='tooltip'
    data-bulk-action-target='button'
    data-action='click->bulk-action#submit'
    title=title
  }
    span.icon = fa_icon :box_archive, class: icon_class
    span.icon.d-none = fa_icon :spinner, class: icon_class, animation: 'spin'
SLIM
