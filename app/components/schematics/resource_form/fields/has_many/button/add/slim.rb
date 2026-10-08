# frozen_string_literal: true

Schematics::ResourceForm::Fields::HasMany::Button::Add::SLIM = <<~SLIM
  button.btn.btn-sm.btn-icon-split.bg-body-tertiary.mb-3 {
    data-action='click->nested-form#add:prevent'
    data-nested-form-template-id-param=template_id
    data-nested-form-target-id-param=target_id
  }
    span.icon = fa_icon :plus
    span.text = t('schematics.application.button.add', human_name:, gender:)
SLIM
