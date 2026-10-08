# frozen_string_literal: true

Schematics::Viewer::EventButtonGroup::Button::SLIM = <<~SLIM
  = link_to url, title: event.human, data:, role: 'button', class: button_css_classes do
    span.icon = fa_icon event.icon
    span.icon.d-none = fa_icon :spinner, animation: 'spin'
    span.text.d-none.d-xxl-inline = event.human unless compact?
    span.text.d-none = t('.loading') unless compact?
SLIM
