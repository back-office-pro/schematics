# frozen_string_literal: true

Schematics::ResourceForm::Fields::HasMany::Button::Remove::SLIM = <<~SLIM
  button.btn.btn-danger.btn-sm.btn-icon-split {
    data-action='click->nested-form#remove:prevent'
    data-nested-form-wrapper-param=wrapper
  }
    span.icon = fa_icon :trash
    span.text.d-none.d-lg-inline = t('schematics.application.button.remove', human_name:, gender:)
SLIM
