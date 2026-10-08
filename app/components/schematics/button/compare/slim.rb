# frozen_string_literal: true

Schematics::Button::Compare::SLIM = <<~SLIM
  button.btn.btn-sm.pe-1.d-none {
    data-controller='tooltip'
    data-comparison-target='button'
    data-action='click->comparison#submit'
    title=title
  }
    span.icon = fa_icon icon, class: icon_class
    span.icon.d-none = fa_icon :spinner, class: icon_class, animation: 'spin'
SLIM
