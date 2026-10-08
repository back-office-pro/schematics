# frozen_string_literal: true

Schematics::Viewer::EventButtonGroup::ConfirmButton::SLIM = <<~SLIM
  = form_with url:, method: :patch, class: form_css_classes
    = __confirm_dialog(target:, text:)
  = button_tag data:, title: event.human, class: button_css_classes do
    span.icon = fa_icon event.icon
    span.text.d-none.d-xxl-inline = event.human unless compact?
SLIM
